#ifndef NX_AUDIO_WAVEENCODER_HPP
#define NX_AUDIO_WAVEENCODER_HPP

#include <cstdio>
#include <string>
#include <fstream>
#include <lame.h>
#include <sndfile.h>
#pragma comment(lib, "libmp3lame.a")
#pragma comment(lib, "libsndfile.a")

namespace Nx
{
	namespace Audio
	{
		class WaveEncoder
		{
			std::string m_source;
			std::string m_lastErrorMessage;
			int m_quality;

		public:
			WaveEncoder(const std::string &sourceFileName, int quality = 3);
			~WaveEncoder();

			std::string GetLastErrorMessage() { return m_lastErrorMessage; }

			bool ToMP3(const std::string &destFileName);
			bool ToOGG(const std::string &destFileName);
		};
	}
}

#endif
