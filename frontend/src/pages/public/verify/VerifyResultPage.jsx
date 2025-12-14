import { AlertTriangle, ArrowLeft, CheckCircle2, Loader2, ShieldCheck } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useNavigate, useParams, useSearchParams } from 'react-router-dom';
import VerificationCard from '@/components/verify/VerificationCard';
import { verifyRecord } from '@/services/verify.service';

const STEPS = [
  { id: 1, label: 'Connecting to Blockchain Node', delay: 800 },
  { id: 2, label: 'Retrieving Smart Contract Data', delay: 1500 },
  { id: 3, label: 'Verifying Digital Signature', delay: 2200 },
  { id: 4, label: 'Checking Integrity Proof', delay: 3000 },
];

const VerifyResultPage = () => {
  const { id } = useParams();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const queryId = searchParams.get('id');
  const recordId = id || queryId;

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentStep, setCurrentStep] = useState(0);

  useEffect(() => {
    if (!recordId) {
      setError('No Record ID provided');
      setLoading(false);
      return;
    }

    // Determine total simulation time based on steps
    const simulationDuration = STEPS[STEPS.length - 1].delay + 500;

    // Start verification API call immediately
    const verifyPromise = verifyRecord(recordId);

    // Run step simulation
    const timers = STEPS.map((step, index) => {
      return setTimeout(() => {
        setCurrentStep(index + 1);
      }, step.delay);
    });

    // Handle API result
    Promise.all([
      verifyPromise,
      new Promise((resolve) => setTimeout(resolve, simulationDuration)), // Ensure animation completes
    ])
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
  }, [recordId]);

  const handleBack = () => navigate('/verify');

  if (loading) {
    return (
      <div className="min-h-screen w-full flex flex-col items-center justify-center bg-slate-900 text-white relative overflow-hidden">
        {/* Background effects */}
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
                          ? 'border-blue-500 bg-blue-500/20'
                          : 'border-slate-700 bg-slate-800'
                    }
                  `}
                  >
                    {isCompleted ? (
                      <CheckCircle2 size={14} className="text-white" />
                    ) : isActive ? (
                      <div className="w-2 h-2 bg-blue-500 rounded-full animate-ping" />
                    ) : (
                      <div className="w-2 h-2 bg-slate-600 rounded-full" />
                    )}
                  </div>
                  <span
                    className={`font-mono text-sm tracking-wide ${
                      isActive
                        ? 'text-blue-400 font-bold'
                        : isCompleted
                          ? 'text-emerald-400'
                          : 'text-slate-500'
                    }`}
                  >
                    {step.label}...
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen w-full flex flex-col items-center justify-center bg-slate-900 text-white p-6">
        <div className="bg-red-500/10 p-6 rounded-full border border-red-500/20 mb-6 animate-bounce-slow">
          <AlertTriangle size={48} className="text-red-500" />
        </div>

        <h2 className="text-2xl font-bold text-slate-100 tracking-tight mb-2">
          VERIFICATION FAILED
        </h2>

        <div className="bg-slate-800 px-4 py-2 rounded-lg border border-slate-700 font-mono text-red-400 text-sm mb-8">
          {error.toUpperCase()}
        </div>

        <button
          type="button"
          onClick={handleBack}
          className="group flex items-center gap-2 px-6 py-3 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 transition-all border border-slate-700 hover:border-slate-600"
        >
          <ArrowLeft size={18} className="group-hover:-translate-x-1 transition-transform" />
          <span>Return to Safety</span>
        </button>
      </div>
    );
  }

  return (
    <div className="min-h-screen w-full flex flex-col items-center bg-slate-50 relative overflow-hidden">
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-[0.03] bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px]" />

      {/* Header */}
      <div className="w-full max-w-5xl mx-auto px-6 py-6 flex justify-between items-center relative z-10">
        <button
          type="button"
          onClick={handleBack}
          className="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 rounded-xl text-slate-600 font-medium shadow-sm hover:bg-slate-50 transition-colors"
        >
          <ArrowLeft size={18} /> Back
        </button>

        <div className="flex items-center gap-2 px-4 py-1.5 bg-slate-900 text-white rounded-full text-xs font-bold tracking-wider shadow-lg shadow-slate-900/10">
          <div className="w-2 h-2 bg-emerald-400 rounded-full animate-pulse" />
          VERIFIED LIVE
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 w-full max-w-md px-6 flex flex-col justify-center items-center pb-20 relative z-10 animate-fade-in-up">
        <VerificationCard data={data} />

        <div className="mt-8 flex items-center gap-2 text-slate-400 text-xs font-mono tracking-widest opacity-60">
          <ShieldCheck size={14} />
          SECURED BY VAXSAFE PROTOCOL v2.0
        </div>
      </div>

      <style>{`
        @keyframes bounce-slow {
          0%, 100% { transform: translateY(-5%); }
          50% { transform: translateY(5%); }
        }
        .animate-bounce-slow {
          animation: bounce-slow 2s infinite ease-in-out;
        }
        @keyframes fadeInUp {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in-up {
          animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
      `}</style>
    </div>
  );
};

export default VerifyResultPage;
