#!/usr/bin/python3

from azure.cognitiveservices.speech import AudioDataStream, SpeechConfig, SpeechSynthesizer, SpeechSynthesisOutputFormat
import azure.cognitiveservices.speech as speechsdk
from azure.cognitiveservices.speech.audio import AudioOutputConfig


voice = "zh-CN-XiaoxiaoNeural"
text = '你好'
speech_config = SpeechConfig(subscription="3cb77646eea84168b348969306ff2a3c", region="eastus")
speech_config.speech_synthesis_voice_name = voice
audio_config = AudioOutputConfig(filename="file.wav")
synthesizer = SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
result = synthesizer.speak_text_async(text).get()

# Check result
if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
    print("Speech synthesized to speaker for text [{}] with voice [{}]".format(text, voice))
elif result.reason == speechsdk.ResultReason.Canceled:
    cancellation_details = result.cancellation_details
    print("Speech synthesis canceled: {}".format(cancellation_details.reason))
    if cancellation_details.reason == speechsdk.CancellationReason.Error:
        print("Error details: {}".format(cancellation_details.error_details))
