Engine_Sawed : CroneEngine {

	// ** add your variables here **
	var params;
	// This is called when the engine is actually loaded by a script.
	// You can assume it will be called in a Routine,
	//  and you can use .sync and .wait methods.
	alloc { // allocate memory to the following:

		// ** add your SynthDefs here **
		SynthDef("Sawed", {

			arg atk, sus, rel, c1, c2, freq, fMult, detune, pan, cfhzmin, cfhzmax, cfmin, cfmax, rqmin, rqmax,lsf, ldb, amp, out = 0;

			var sig, env;

			env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], [c1,0, c2]), doneAction:2);

			sig = Saw.ar((freq) *{LFNoise1.kr(0.25,detune).midiratio}!2);

			sig = BPF.ar(
				sig,
				{LFNoise1.kr(0.75).exprange(cfmin,cfmax)}!2,
				{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2);

			sig = BLowShelf.ar(sig, lsf, 0.5, ldb);

			sig = Balance2.ar(sig[0], sig[1], pan);

			sig = sig * env * amp;

			Out. ar(out, sig);
		}).add;
		// if you need your SynthDef to be available before commands are sent,
		//  sync with the server by ** uncommenting the following line **:
		// Server.default.sync;

		// ** add your commands here **

		params = Dictionary.newFrom([
			\atk, 5,
			\sus, 0,
			\rel, 8,
			\c1, 1,
			\c2, (-1),
			\freq, 200,
			\fMult, 1,
			\detune, 0.02,
			\pan, 0,
			\cfhzmin, 0.1,
			\cfhzmax, 0.2,
			\cfmin, 100,
			\cfmax, 101,
			\rqmin,0.005,
			\rqmax, 0.009,
			\lsf, 40,
			\ldb, 0,
			\amp, 1,
		]);

		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

		this.addCommand("hz", "f", { arg msg;
			Synth.new("Sawed", [\freq, msg[1]] ++ params.getPairs)
		});

	}

}







