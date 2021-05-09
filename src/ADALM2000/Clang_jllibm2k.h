// stripped down C-style header for wrapping with Clang.jl

// contextbuilder.hpp
//std::vector<libm2k::CONTEXT_INFO*> getintsInfo();
//std::vector<const char*> getAllints();
//int* contextOpen(const char*);
//int* contextOpen(struct iio_context*, const char*);
int* contextOpen();
//int* m2kOpen(const char*);
//int* m2kOpen(struct iio_context*, const char*);
int* m2kOpen();
void contextClose(int*);
//void contextCloseAll();
//const char* getVersion();


// context.hpp
// char* getUri(int*);
 int* getDMM(int*, unsigned int index);
// int* getDMM(const char* name);
// std::vector< int* > getAllDmm();
// std::vector< const char* > getAvailableintAttributes();
// const char* getintAttributeValue(int*, const char* attr);
// const char* getintDescription(int*);
// const char* getSerialNumber(int*);
// std::unordered_set< const char* > getAllDevices();
// void logAllAttributes();
// int* toint();
// Lidar* toLidar();
// Generic* toGeneric();
// unsigned int getDmmCount();
// const char* getFirmwareVersion();
// const struct libm2k::IIO_CONTEXT_VERSION getIiointVersion();
// struct iio_context* getIioint();
// void setTimeout(unsigned int timeout);


// m2k.hpp
 void reset(int* ctx);
 bool calibrateADC(int* ctx);
 bool calibrateDAC(int* ctx);
 double calibrateFromint(int* ctx);
 int* getDigital(int* ctx);
 int* getPowerSupply(int* ctx);
 int* getAnalogIn(int* ctx);
 int* getAnalogIn_(int* ctx , char* dev_name);
 int* getAnalogOut(int* ctx);
 bool hasMixedSignal(int* ctx);
 void startMixedSignalAcquisition(int* ctx, unsigned int nb_samples);
 void stopMixedSignalAcquisition(int* ctx);
 int getDacCalibrationOffset(int* ctx, unsigned int chn);
 double getDacCalibrationGain(int* ctx, unsigned int chn);
 int getAdcCalibrationOffset(int* ctx, unsigned int chn);
 double getAdcCalibrationGain(int* ctx, unsigned int chn);
 void setDacCalibrationOffset(int* ctx, unsigned int chn, int offset);
 void setDacCalibrationGain(int* ctx, unsigned int chn, double gain);
 void setAdcCalibrationOffset(int* ctx, unsigned int chn, int offset);
 void setAdcCalibrationGain(int* ctx, unsigned int chn, double gain);
 bool hasintCalibration(int* ctx);
// std::map< double, std::shared_ptr< struct CALIBRATION_PARAMETERS > > &getLUT();
 bool isCalibrated(int* ctx);
 void setLed(int* ctx, bool on);
 bool getLed(int* ctx);


// m2kanalogin.hpp
void startAcquisition(int* ain, unsigned int nb_samples);
void stopAcquisition(int* ain);
//chdata* getSamples(int* ain, unsigned int nb_samples);
//std::vector< std::vector< double > > getSamplesRaw(int* ain, unsigned int nb_samples);
const double* getSamplesInterleaved(int* ain, unsigned int nb_samples);
//const short* getSamplesRawInterleaved(int* ain, unsigned int nb_samples);
//short getVoltageRaw(int* ain, unsigned int ch);
double getVoltage(int* ain, unsigned int ch);
//short getVoltageRaw(int* ain, libm2k::analog::ANALOG_IN_CHANNEL ch);
//double getVoltage(int* ain, libm2k::analog::ANALOG_IN_CHANNEL ch);
//std::vector< short > getVoltageRaw(int* ain);
//std::vector< double > getVoltage(int* ain);
//const short* getVoltageRawP(int* ain);
//const double* getVoltageP(int* ain);
void setVerticalOffset(int* ain, unsigned int channel, double vertOffset);
double getVerticalOffset(int* ain, unsigned int  channel);
double getScalingFactor(int* ain, unsigned int ch);
void setRange(int* ain, unsigned int channel, unsigned int range);
void setRangeMinMax(int* ain, unsigned int channel, double min, double max);
//libm2k::analog::M2K_RANGE getRange(int* ain, libm2k::analog::ANALOG_IN_CHANNEL channel);
//std::pair< double, double > getRangeLimits(int* ain, libm2k::analog::M2K_RANGE range);
//std::vector< std::pair< const char*, std::pair< double, double > > > getAvailableRanges(int* ain);
//int getOversamplingRatio(int* ain);
//int getOversamplingRatio(int* ain, unsigned int chn_idx);
//int setOversamplingRatio(int* ain, int oversampling);
//int setOversamplingRatio(int* ain, unsigned int chn_idx, int oversampling);
double getSampleRate(int* ain);
//std::vector< double > getAvailableSampleRates(int* ain);
double setSampleRate(int* ain, double samplerate);
//std::pair< double, double > getHysteresisRange(int* ain, ANALOG_IN_CHANNEL chn);
double getFilterCompensation(int* ain, double samplerate);
//double getValueForRange(int* ain, M2K_RANGE range);
//double convertRawToVolts(int* ain, unsigned int channel, short raw);
//short convertVoltsToRaw(int* ain, unsigned int channel, double voltage);
unsigned int getNbChannels(int* ain);
const char* getNameAin(int* ain);
void enableChannel(int* ain, unsigned int chnIdx, bool enable);
bool isChannelEnabled(int* ain, unsigned int chnIdx);
void cancelAcquisition(int* ain);
void setKernelBuffersCount(int* ain, unsigned int count);
int* getTrigger(int* ain);
//struct IIO_OBJECTS getIioObjects(int* ain);
//void getSamples(int* ain, std::vector< std::vector< double >> &data, unsigned int nb_samples);
//const char* getChannelName(int* ain, unsigned int channel);
double getMaximumSamplerate(int* ain);


// dmm.hpp
//std::vector< const char* > getAllChannels();
double readChannelDmm(int* ain, unsigned int index);
//int_READING readChannel(const char* chn_name);
//std::vector< int_READING > readAll();
const char* getNameDmm(int* ain);


// analogout.hpp
//std::vector< int > getOversamplingRatio();
//int getOversamplingRatio(unsigned int chn);
//std::vector< int > setOversamplingRatio(std::vector< int > oversampling_ratio);
//int setOversamplingRatio(unsigned int chn, int oversampling_ratio);
//std::vector< double > getSampleRate();
double getSampleRateFgen(int* fgen, unsigned int chn);
//std::vector< double > getAvailableSampleRates(unsigned int chn);
//std::vector< double > setSampleRate(std::vector< double > samplerates);
double setSampleRateFgen(int* fgen, unsigned int chn, double samplerate);
void setCyclic(int* fgen, bool en);
void setCyclicCh(int* fgen, unsigned int chn, bool en);
bool getCyclic(int* fgen, unsigned int chn);
double getScalingFactorFgen(int* fgen, unsigned int chn);
double getFilterCompensationFgen(int* fgen, double samplerate);
//void pushBytes(unsigned int chnIdx, double* data, unsigned int nb_samples);
//void pushRawBytes(unsigned int chnIdx, short* data, unsigned int nb_samples);
void pushInterleaved(int* fgen, double* data, unsigned int nb_channels, unsigned int nb_samples);
//void pushRawInterleaved(short* data, unsigned int nb_channels, unsigned int nb_samples);
//void push(unsigned int chnIdx, std::vector< double > const& data);
//void pushRaw(unsigned int chnIdx, std::vector< short > const& data);
//void push(std::vector< std::vector< double >> const& data);
//void pushRaw(std::vector< std::vector< short >> const& data);
void stopAllFgen(int* fgen);
void stopFgen(int* fgen, unsigned int chn);
void cancelBufferAllFgen(int* fgen);
void cancelBufferFgen(int* fgen, unsigned int chn);
void enableChannelFgen(int* fgen, unsigned int chnIdx, bool enable);
bool isChannelEnabledFgen(int* fgen, unsigned int chnIdx);
void setKernelBuffersCountFgen(int* fgen, unsigned int chnIdx, unsigned int count);
//short convertVoltsToRaw(unsigned int channel, double voltage);
//double convertRawToVolts(unsigned int channel, short raw);
//struct IIO_OBJECTS getIioObjects();
//unsigned int getNbChannels();
const char* getChannelNameFgen(int* fgen, unsigned int channel);
double getMaximumSamplerateFgen(int* fgen, unsigned int chn_idx);


// powersupply.hpp
void enableChannelPsu(intPowerSupply*, unsigned int chn, bool en);
void enableAllPsu(intPowerSupply*, bool en);
double readChannelPsu(intPowerSupply*, unsigned int chn);
void pushChannelPsu(intPowerSupply*, unsigned int chn, double value);
bool anyChannelEnabledPsu(intPowerSupply*);

/*
// digital.hpp
void setDirection(unsigned short mask);
void setDirection(unsigned int index, DIO_DIRECTION dir);
void setDirection(unsigned int index, bool dir);
void setDirection(DIO_CHANNEL index, bool dir);
void setDirection(DIO_CHANNEL index, DIO_DIRECTION dir);
DIO_DIRECTION getDirection(DIO_CHANNEL index);
void setValueRaw(DIO_CHANNEL index, DIO_LEVEL level);
void push(std::vector< unsigned short > const& data);
void push(unsigned short* data, unsigned int nb_samples);
void setValueRaw(unsigned int index, DIO_LEVEL level);
void setValueRaw(DIO_CHANNEL index, bool level);
DIO_LEVEL getValueRaw(DIO_CHANNEL index);
DIO_LEVEL getValueRaw(unsigned int index);
void stopBufferOut();
void startAcquisition(unsigned int nb_samples);
void stopAcquisition();
void cancelAcquisition();
void cancelBufferOut();
std::vector< unsigned short > getSamples(unsigned int nb_samples);
const unsigned short* getSamplesP(unsigned int nb_samples);
void enableChannel(unsigned int index, bool enable);
void enableChannel(DIO_CHANNEL index, bool enable);
void enableAllOut(bool enable);
bool anyChannelEnabled(DIO_DIRECTION dir);
void setOutputMode(DIO_CHANNEL chn, DIO_MODE mode);
void setOutputMode(unsigned int chn, DIO_MODE mode);
DIO_MODE getOutputMode(DIO_CHANNEL chn);
DIO_MODE getOutputMode(unsigned int chn);
double setSampleRateIn(double samplerate);
double setSampleRateOut(double samplerate);
double getSampleRateIn();
double getSampleRateOut();
bool getCyclic();
void setCyclic(bool cyclic);
int * getTrigger();
void setKernelBuffersCountIn(unsigned int count);
void setKernelBuffersCountOut(unsigned int count);
struct IIO_OBJECTS getIioObjects();
unsigned int getNbChannelsIn();
unsigned int getNbChannelsOut();
void getSamples(std::vector< unsigned short > &data, unsigned int nb_samples);
void setRateMux();
void resetRateMux();
/*/


// m2ktrigger.hpp
// TODO: test all
// TODO: test how ENUMS are imported and exported to Julia
int getAnalogLevelRaw(int* trg, unsigned int chnIdx);
void setAnalogLevelRaw(int* trg, unsigned int chnIdx, int level);
void setAnalogLevel(int* trg, unsigned int chnIdx, double v_level);
double getAnalogLevel(int* trg, unsigned int chnIdx);
double getAnalogHysteresis(int* trg, unsigned int chnIdx);
void setAnalogHysteresis(int* trg, unsigned int chnIdx, double hysteresis);
//M2K_TRIGGER_CONDITION_ANALOG getAnalogCondition(int* trg, unsigned int chnIdx);
//void setAnalogCondition(int* trg, unsigned int chnIdx, M2K_TRIGGER_CONDITION_ANALOG cond);
//M2K_TRIGGER_CONDITION_DIGITAL getDigitalCondition(int* trg, unsigned int chnIdx);
//void setDigitalCondition(int* trg, unsigned int chnIdx, unsigned int cond);
//M2K_TRIGGER_MODE getAnalogMode(int* trg, unsigned int chnIdx);
void setAnalogMode(int* trg, unsigned int chnIdx, unsigned int mode);
//libm2k::digital::DIO_TRIGGER_MODE getDigitalMode(int* trg);
void setDigitalMode(int* trg, unsigned int mode);
//M2K_TRIGGER_SOURCE_ANALOG getAnalogSource(int* trg);
void setAnalogSource(int* trg, unsigned int src);
int getAnalogSourceChannel(int* trg);
void setAnalogSourceChannel(int* trg, unsigned int chnIdx);
int getAnalogDelay(int* trg);
void setAnalogDelay(int* trg, int delay);
int getDigitalDelay(int* trg);
void setDigitalDelay(int* trg, int delay);
void setAnalogStreamingFlag(int* trg, bool enable);
bool getAnalogStreamingFlag(int* trg);
void setDigitalStreamingFlag(int* trg, bool enable);
bool getDigitalStreamingFlag(int* trg);
//M2K_TRIGGER_CONDITION_DIGITAL getAnalogExternalCondition(int* trg, unsigned int chnIdx);
//void setAnalogExternalCondition(int* trg, unsigned int chnIdx, unsigned int cond);
//M2K_TRIGGER_CONDITION_DIGITAL getDigitalExternalCondition(int* trg);
void setDigitalExternalCondition(int* trg, unsigned int cond);
void setAnalogExternalOutSelect(int* trg, unsigned int output_select);
//M2K_TRIGGER_OUT_SELECT getAnalogExternalOutSelect(int* trg);
void setDigitalSource(int* trg, unsigned int external_src);
//M2K_TRIGGER_SOURCE_DIGITAL getDigitalSource(int* trg);
