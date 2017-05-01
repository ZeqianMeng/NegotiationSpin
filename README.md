# NegotiationSpin
The Spin mode source for the proposed negotiation protocol.

negotiation_1.pml is for: access negotiation happens within resource negotiation.

negotiation_2.pml is for: access negotiation happens within pre-negotiation phase.

to download and install Spin:
file:///Applications/MyApp/Spin/README.html

to test the developed model, go to the directory where stores the pml files and run the following commands in ternimal:

	spin -a xxxxx.pml   # lynch's protocol - generate verifier
	cc -o pan pan.c    # compile it for exhaustive verification
	./pan              # prove correctness of assertions etc.
	spin -t -r -s xxxxx.pml # display the error trace (only run when the verification returns errors)

to test the developed model with interactive and guided simulation, go to the directory where stores the pml files and run the command:
spin -i xxxxx.pml 

then follow the instructions shown in terminal.
