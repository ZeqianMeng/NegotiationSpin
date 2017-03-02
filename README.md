# NegotiationSpin
The Spin mode source for the proposed negotiation protocol.

negotiation_1.pml is for: access negotiation happens within resource negotiation.

negotiation_2.pml is for: access negotiation happens within pre-negotiation phase.

to download and install Spin:
file:///Applications/MyApp/Spin/README.html

to test the developed model, run the following commands in ternimal:

	spin -a xxxxx.pml   # lynch's protocol - generate verifier
	cc -o pan pan.c    # compile it for exhaustive verification
	./pan              # prove correctness of assertions etc.
	spin -t -r -s xxxxx.pml # display the error trace (only run when the verification returns errors)
