import {
  Activity,
  AlertTriangle,
  ArrowLeft,
  BadgeCheck,
  Calendar,
  CheckCircle2,
  Download,
  Loader2,
  ShieldCheck,
  Syringe,
} from 'lucide-react';
import { QRCodeCanvas } from 'qrcode.react';
import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import {
  getRecordsByIdentity,
  getVaccineDosesByIdentity,
  verifySpecificDose,
} from '@/services/verify.service';

const STEPS = [
  { id: 1, label: 'Connecting to Blockchain Node', delay: 600 },
  { id: 2, label: 'Querying Smart Contract', delay: 1200 },
  { id: 3, label: 'Verifying Records', delay: 1800 },
  { id: 4, label: 'Fetching IPFS Data', delay: 2400 },
];

const VerifySearchResultPage = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();

  const identityHash = searchParams.get('identity');
  const vaccineSlug = searchParams.get('vaccine');
  const doseNumber = searchParams.get('dose');

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentStep, setCurrentStep] = useState(0);
  const [searchType, setSearchType] = useState(''); // 'specific-dose', 'vaccine-doses', 'all-records'

  useEffect(() => {
    if (!identityHash) {
      setError('No Identity Hash provided');
      setLoading(false);
      return;
    }

    const simulationDuration = STEPS[STEPS.length - 1].delay + 500;

    // Determine which API to call based on params
    let apiPromise;
    if (vaccineSlug && doseNumber) {
      setSearchType('specific-dose');
      apiPromise = verifySpecificDose(vaccineSlug, parseInt(doseNumber, 10), identityHash);
    } else if (vaccineSlug) {
      setSearchType('vaccine-doses');
      apiPromise = getVaccineDosesByIdentity(vaccineSlug, identityHash);
    } else {
      setSearchType('all-records');
      apiPromise = getRecordsByIdentity(identityHash);
    }

    // Run step simulation
    const timers = STEPS.map((step, index) => {
      return setTimeout(() => {
        setCurrentStep(index + 1);
      }, step.delay);
    });

    // Handle API result
    Promise.all([apiPromise, new Promise((resolve) => setTimeout(resolve, simulationDuration))])
      .then(([result]) => {
        setData(result);
        setLoading(false);
      })
      .catch((err) => {
        setError(err?.response?.data?.message || err.message || 'Verification Failed');
        setLoading(false);
      })
      .finally(() => {
        timers.forEach(clearTimeout);
      });

    return () => timers.forEach(clearTimeout);
  }, [identityHash, vaccineSlug, doseNumber]);

  const handleBack = () => navigate('/verify');

  if (loading) {
    return (
      <div className="min-h-screen w-full flex flex-col items-center justify-center bg-slate-900 text-white relative overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-blue-900/20 via-slate-900 to-slate-900" />

        <div className="z-10 w-full max-w-md px-6">
          <div className="flex justify-center mb-8">
            <div className="relative">
              <div className="absolute inset-0 bg-blue-500 blur-xl opacity-20 animate-pulse" />
              <Loader2 className="w-16 h-16 text-blue-500 animate-spin relative z-10" />
            </div>
          </div>

          <div className="space-y-4">
            {STEPS.map((step, index) => {
              const isActive = currentStep === index + 1;
              const isCompleted = currentStep > index + 1;
              const isPending = currentStep <= index;

              return (
                <div
                  key={step.id}
                  className={`flex items-center gap-4 transition-all duration-500 ${
                    isPending ? 'opacity-30 translate-y-2' : 'opacity-100 translate-y-0'
                  }`}
                >
                  <div
                    className={`
                    w-6 h-6 rounded-full flex items-center justify-center border transition-colors duration-300
                    ${
                      isCompleted
                        ? 'bg-emerald-500 border-emerald-500'
                        : isActive
                          ? 'bg-blue-500 border-blue-500 animate-pulse'
                          : 'bg-transparent border-slate-600'
                    }
                  `}
                  >
                    {isCompleted && <CheckCircle2 className="w-4 h-4 text-white" />}
                  </div>
                  <span className={`text-sm ${isActive ? 'text-white' : 'text-slate-400'}`}>
                    {step.label}
                  </span>
                </div>
              );
            })}
          </div>

          <div className="mt-8 text-center">
            <p className="text-slate-400 text-sm">
              {searchType === 'specific-dose' &&
                `Verifying Dose ${doseNumber} of ${vaccineSlug}...`}
              {searchType === 'vaccine-doses' && `Fetching all doses of ${vaccineSlug}...`}
              {searchType === 'all-records' && 'Fetching all vaccination records...'}
            </p>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen w-full flex flex-col items-center justify-center bg-slate-900 text-white relative overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-red-900/20 via-slate-900 to-slate-900" />

        <div className="z-10 text-center px-6 max-w-md">
          <div className="bg-red-500/10 p-6 rounded-full w-fit mx-auto mb-6 border border-red-500/30">
            <AlertTriangle className="w-16 h-16 text-red-500" />
          </div>
          <h1 className="text-2xl font-bold mb-4">Verification Failed</h1>
          <p className="text-slate-400 mb-8">{error}</p>
          <button
            onClick={handleBack}
            className="inline-flex items-center gap-2 px-6 py-3 bg-slate-800 hover:bg-slate-700 rounded-full font-medium transition-colors"
          >
            <ArrowLeft size={20} />
            Try Again
          </button>
        </div>
      </div>
    );
  }

  // Render results based on search type
  const records = Array.isArray(data) ? data : [data];
  const isMultiple = records.length > 1;

  return (
    <div className="min-h-screen w-full bg-gradient-to-br from-slate-50 to-blue-50 relative">
      {/* Header */}
      <header className="px-6 md:px-12 py-6 flex items-center justify-between">
        <button
          onClick={handleBack}
          className="flex items-center gap-2 text-slate-600 hover:text-slate-900 transition-colors font-medium"
        >
          <ArrowLeft size={20} />
          <span>Back to Search</span>
        </button>
        <div className="flex items-center gap-2 text-emerald-600 font-semibold">
          <ShieldCheck size={20} />
          <span>Blockchain Verified</span>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-6 pb-12">
        {/* Summary Card */}
        <div className="bg-white rounded-2xl shadow-xl border border-slate-100 p-6 mb-8">
          <div className="flex items-center gap-4 mb-4">
            <div className="bg-emerald-100 p-3 rounded-xl">
              <CheckCircle2 className="w-8 h-8 text-emerald-600" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-slate-900">
                {searchType === 'specific-dose' && 'Dose Verification Successful'}
                {searchType === 'vaccine-doses' && `Found ${records.length} Dose(s)`}
                {searchType === 'all-records' && `Found ${records.length} Vaccination Record(s)`}
              </h1>
              <p className="text-slate-500">
                Identity: {identityHash?.substring(0, 12)}...
                {identityHash?.substring(identityHash.length - 6)}
              </p>
            </div>
          </div>

          {vaccineSlug && (
            <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 px-4 py-2 rounded-full text-sm font-medium">
              <Syringe size={16} />
              <span>{vaccineSlug}</span>
              {doseNumber && (
                <span className="bg-blue-600 text-white px-2 py-0.5 rounded-full text-xs">
                  Dose {doseNumber}
                </span>
              )}
            </div>
          )}
        </div>

        {/* Records Grid */}
        <div className={`grid gap-6 ${isMultiple ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
          {records.map((record, index) => (
            <RecordCard key={record.id || index} record={record} index={index} />
          ))}
        </div>
      </main>
    </div>
  );
};

const RecordCard = ({ record, index }) => {
  if (!record) return null;

  return (
    <div className="bg-white rounded-2xl shadow-lg border border-slate-100 overflow-hidden">
      {/* Header */}
      <div className="bg-slate-900 p-4 flex items-center justify-between">
        <div className="flex items-center gap-2 text-emerald-400 text-sm font-semibold">
          <BadgeCheck size={16} />
          <span>VERIFIED RECORD</span>
        </div>
        <span className="text-slate-400 text-xs font-mono">#{record.id}</span>
      </div>

      <div className="p-6">
        {/* Vaccine Info */}
        <div className="flex items-start justify-between mb-6">
          <div>
            <h3 className="text-xl font-bold text-slate-900 mb-1">{record.vaccineName}</h3>
            <p className="text-slate-500 text-sm">{record.manufacturer}</p>
          </div>
          <div className="bg-blue-50 px-3 py-1.5 rounded-lg">
            <span className="text-blue-700 font-bold">
              Dose {record.doseNumber}/{record.dosesRequired || '?'}
            </span>
          </div>
        </div>

        {/* Details Grid */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <div>
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
              Vaccination Date
            </label>
            <div className="flex items-center gap-2 mt-1">
              <Calendar size={16} className="text-slate-400" />
              <span className="font-medium text-slate-700">{record.vaccinationDate}</span>
            </div>
          </div>
          <div>
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
              Center
            </label>
            <p className="font-medium text-slate-700 mt-1 truncate">{record.centerName}</p>
          </div>
          <div>
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
              Doctor
            </label>
            <p className="font-medium text-slate-700 mt-1 truncate">{record.doctorName}</p>
          </div>
          <div>
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
              Site
            </label>
            <p className="font-medium text-slate-700 mt-1">{record.site || 'N/A'}</p>
          </div>
        </div>

        {/* Blockchain Info */}
        <div className="bg-slate-50 rounded-xl p-4 space-y-3">
          <div className="flex items-center gap-2 text-slate-700 font-mono text-xs">
            <Activity size={14} className="text-emerald-500 shrink-0" />
            <span className="truncate">TX: {record.transactionHash}</span>
          </div>
          <div className="flex items-center gap-2 text-slate-700 font-mono text-xs">
            <Download size={14} className="text-blue-500 shrink-0" />
            <span className="truncate">IPFS: {record.ipfsHash}</span>
          </div>
        </div>

        {/* QR Code */}
        {record.ipfsHash && (
          <div className="mt-4 flex justify-center">
            <div className="p-2 border-2 border-dashed border-slate-200 rounded-xl">
              <QRCodeCanvas
                value={`${window.location.origin}/verify/${record.ipfsHash}`}
                size={80}
                level={'H'}
              />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default VerifySearchResultPage;
