Constellation figures for Cartes du Ciel

The program convert the file DefaultConstL.txt to DefaultConstL.cln for use with CdC V3.

convconstl is the old program that use the BSC catalog directly. The BSC catalog contain pre-Hipparcos data so the proper motion cannot be derived reliably.

xhipconstl is the new program to build the constellation lines using the Hipparcos data.
This program allow to specify a target epoch to correct the stars position from proper motion. In practice the same file can be used for a few thousand years without problem.

You can change the output file name to quickly change the file for the correct epoch in CdC. For example DefaultConstL2000BC.cln, DefaultConstL4000BC.cln, ...

The data file cdc_xhip_hr.dat is build with the program cdc_xhip_hr.pp in the cat/xhip/src folder.

Unfortunately all the HR stars are not in Hipparcos, principally the double stars have generally a single component.

In the case you get an error in the form:
  HR5506 not in Hipparcos, ignoring this point.

Look in the file bsc_catalog.dat for this star:
5506 36Eps BooBD+27 2417 129989 83500    I   9372A ...
and you seee just above:
5505 36Eps BooBD+27 2417 129988              9372B ...

Then change 5506 by 5505 in your file to use the component B instead of A because only B is in Hipparcos.



