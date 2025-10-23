Engine_Sawed : CroneEngine {

	// ** add your variables here **
	var params;
	// This is called when the engine is actually loaded by a script.
	// You can assume it will be called in a Routine,
	//  and you can use .sync and .wait methods.
	alloc { // allocate memory to the following:

		// ** add your SynthDefs here **
		SynthDef("Sawed", {

			arg atk, sus, rel, c1, c2, freq, fMult, detune,
			pan, driftSpeed, driftSpread, driftStart, wrap,
			cfmin, cfmax, rqmin, rqmax, deviate, c3,
			lf, lAmp, amp, out = 0;

			var sig, env, totalEnv, reeq, dev;

			pan = Select.kr(wrap,[
				SinOsc.kr(driftSpeed,0,driftSpread,driftStart),
				SinOsc.kr(driftSpeed,0,driftSpread,driftStart+1).mod(2)-1
			]);

			totalEnv = atk+rel+sus;
			reeq = rrand(rqmin,rqmax);
			dev = EnvGen.kr(Env([reeq,reeq*deviate],[totalEnv],c3));
			env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], [c1,0, c2]), doneAction:2);

			sig = Saw.ar((freq) *{LFNoise1.kr(0.25,detune).midiratio}!2);

			sig = Resonz.ar(
				sig,
				{LFNoise1.kr(0.75).exprange(cfmin,cfmax)}!2,
				{dev}!2);


			sig = BLowShelf.ar(sig, lf, 0.5, lAmp);

			sig = LPF.ar(sig,cfmin*8);

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
			\c1, 3,
			\c2, (-3),
			\freq, 200,
			\fMult, 1,
			\detune, 0.02,
			\pan, 0,
			\driftSpeed, 0.125,
			\driftSpread, 0.3,
			\driftStart, 0,
			\wrap, 0,
			\cfmin, 100,
			\cfmax, 101,
			\rqmin,0.005,
			\rqmax, 0.009,
			\c3, 3,
			\deviate, 100,
			\lsf, 40,
			\ldb, 6,
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







