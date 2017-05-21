# encoding: utf-8
import ttslab

voice = ttslab.fromfile("wordus.voice.pickle")
utt = voice.synthesize(u'Mea nsia na hunu ewiem nsakrayɛ aa ɛwɔ Kumasi', "text-to-wave")
utt["waveform"].write("test.wav")