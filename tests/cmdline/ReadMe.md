# Command Line Parameter Testing

These command line parameters are tested

  * minidump
  * samplerate
  * symopts

The tests are not so much tests of functionality related to the parameters, but rather tests that the parameters are correctly honored when specified on the command line.



## Overridable Options

Some command line parameters will override what is saved in the application config.

When you specify one of those parameters on the command line, for that instance: the application should not permit you to change the value, nor should it change the value in the saved config.

These parameters exhibit this behavior

  * `/minidump`
  * `/samplerate`
  * `/symsearchpath`
  * `/symcachedir`
  * `/usesymserver` (specify `/usesymserver-` to turn it off)
  * `/symserver`

You can verify the behavior by specifying one or more of the parameters on the command line, then going into Tools / Options, and verify that the corresponding setting shows the override value and cannot be changed.

You can also verify that the saved config data for that setting does not get updated with the value specified on the command line.
