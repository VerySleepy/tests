@echo off
setlocal enabledelayedexpansion

rem  Testing Parameter: samplerate (speed throttle)
rem    The test for this involves counting the number of samples taken during captures whose durations are identical.
rem    Test with a number different sample rates, and verify that the number of samples decreases when the sample rate decreases.
rem      Because sample rate is only a fudge-y way of reducing induced load due to sampling, choose
rem      values for sample rate that _should_ clearly indicate that the rate was higher.
rem      I have also observed that sample rates above 60 or so will not always effect taking more samples.


set "PGMARCH=%~1"
set CONFIG_PARAM=SpeedThrottle

set PREVIOUS_SAMPLES=
for /L %%r in (1, 40, 100) DO (
   @echo Testing Sample Rate: %%r
   call :TEST_SAMPLE_RATE %%r OBSERVED_SAMPLE_COUNT
   if ERRORLEVEL 1 exit /b 1
   @echo    Observed samples: !OBSERVED_SAMPLE_COUNT!
   if not "!PREVIOUS_SAMPLES!"=="" (
       if !PREVIOUS_SAMPLES! gtr !OBSERVED_SAMPLE_COUNT! (
           @echo ERROR: Sample count did not decrease as the sample rate increased.
           exit /b 1
       )
   )
   set /a PREVIOUS_SAMPLES = OBSERVED_SAMPLE_COUNT
)
      
exit /b




:TEST_SAMPLE_RATE
setlocal enabledelayedexpansion

rem  Set the parameter to a different value than what's being tested with.
rem  Perform the profiling capture.
rem  Expand the archive.
rem  Get the number of samples taken from Stats.txt.
rem    Assign that value to the passed-in environment variable name.

SET "TEST_SAMPLERATE_VALUE=%~1"
SET "OUTPUT_VAR=%~2"


set /a START_SAMPLERATE_VALUE=101-!TEST_SAMPLERATE_VALUE!
call ..\..\scripts\set_config_dword "!CONFIG_PARAM!" !START_SAMPLERATE_VALUE!
call ..\..\scripts\get_config "!CONFIG_PARAM!" CHECK_START_SAMPLERATE_VALUE
if not "!CHECK_START_SAMPLERATE_VALUE!"=="!START_SAMPLERATE_VALUE!" (
   @echo PRECONDITION ERROR: failed to set the saved config value for !CONFIG_PARAM!
   exit /b 1
)

@echo  Test SampleRate value: !TEST_SAMPLERATE_VALUE!

if exist "program-!PGMARCH!.sleepy" del "program-!PGMARCH!.sleepy"
if exist "program-!PGMARCH!" rmdir /s /q "program-!PGMARCH!"

call ..\..\scripts\sleepy!pgmarch! /r:program!pgmarch!.exe /o:program-!pgmarch!.sleepy /samplerate:!TEST_SAMPLERATE_VALUE!
if !ERRORLEVEL! neq 0 (
   @echo ERROR: Very Sleepy reports failure: !ERRORLEVEL!
   exit /b 1
)

rem  Get the number of samples.
call ..\..\scripts\get_stat "program-!pgmarch!" Samples OBSERVED_SAMPLES
if !ERRORLEVEL! neq 0 exit /b 1
if "!OBSERVED_SAMPLES!"=="" (
   @echo Unable to find sample count in profile stats.
   exit /b 1
)

rem  Verify that the config value didn't change to what we specified.
rem  It will change if it wasn't set, but not to what we specified.
call ..\..\scripts\get_config "!CONFIG_PARAM!" FINAL_SAMPLERATE_VALUE

IF "!FINAL_SAMPLERATE_VALUE!"=="!TEST_SAMPLERATE_VALUE!" (
   echo ERROR: !CONFIG_PARAM! value was changed to the cmdline override value.
   exit /b 1
)

endlocal & set /a %OUTPUT_VAR% = %OBSERVED_SAMPLES%
exit /b
