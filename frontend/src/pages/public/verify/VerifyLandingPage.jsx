import {
  Activity,
  ArrowRight,
  ChevronDown,
  Filter,
  Globe,
  Lock,
  Search,
  Shield,
  Syringe,
  X,
} from 'lucide-react';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

// Common vaccine options
const VACCINE_OPTIONS = [
  { slug: 'covid-19-pfizer', name: 'COVID-19 (Pfizer-BioNTech)', maxDose: 4 },
  { slug: 'covid-19-moderna', name: 'COVID-19 (Moderna)', maxDose: 4 },
  { slug: 'covid-19-astrazeneca', name: 'COVID-19 (AstraZeneca)', maxDose: 3 },
  { slug: 'hepatitis-b', name: 'Hepatitis B', maxDose: 3 },
  { slug: 'influenza', name: 'Influenza (Cúm)', maxDose: 1 },
  { slug: 'measles-mumps-rubella', name: 'MMR (Sởi-Quai bị-Rubella)', maxDose: 2 },
  { slug: 'tetanus', name: 'Tetanus (Uốn ván)', maxDose: 5 },
  { slug: 'diphtheria', name: 'Diphtheria (Bạch hầu)', maxDose: 5 },
];

const VerifyLandingPage = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [showAdvanced, setShowAdvanced] = useState(false);
  const [advancedSearch, setAdvancedSearch] = useState({
    identityHash: '',
    vaccineSlug: '',
    doseNumber: '',
  });
  const navigate = useNavigate();

  const handleVerify = (e) => {
    e.preventDefault();
    if (searchTerm.trim()) {
      navigate(`/verify/${searchTerm.trim()}`);
    }
  };

  const handleAdvancedSearch = (e) => {
    e.preventDefault();
    const { identityHash, vaccineSlug, doseNumber } = advancedSearch;

    if (!identityHash.trim()) {
      return;
    }

    // Build query params for advanced search
    const params = new URLSearchParams();
    params.set('identity', identityHash.trim());

    if (vaccineSlug) {
      params.set('vaccine', vaccineSlug);
    }

    if (doseNumber) {
      params.set('dose', doseNumber);
    }

    navigate(`/verify/search?${params.toString()}`);
  };

  const selectedVaccine = VACCINE_OPTIONS.find((v) => v.slug === advancedSearch.vaccineSlug);
  const maxDose = selectedVaccine?.maxDose || 5;

  return (
    <div className="min-h-screen w-full flex flex-col overflow-hidden bg-gradient-to-br from-slate-50 to-blue-50 relative selection:bg-blue-100 selection:text-blue-900">
      {/* Background Decor */}
      <div className="absolute -top-24 -right-24 w-[600px] h-[600px] bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute -bottom-24 -left-48 w-[500px] h-[500px] bg-emerald-500/10 rounded-full blur-3xl pointer-events-none" />

      {/* Navbar */}
      <header className="px-6 md:px-12 py-6 flex items-center justify-between z-10">
        {/* biome-ignore lint/a11y/useSemanticElements: interactive logo */}
        <div
          className="flex items-center gap-3 font-extrabold text-2xl text-slate-900 tracking-tight cursor-pointer"
          onClick={() => navigate('/')}
          onKeyDown={(e) => e.key === 'Enter' && navigate('/')}
          role="button"
          tabIndex={0}
        >
          <div className="bg-slate-900 p-2 rounded-xl flex items-center justify-center shadow-lg shadow-slate-900/20">
            <Activity size={20} color="#fff" />
          </div>
          <span>
            Safe<span className="text-blue-600">Vax</span>
          </span>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1 flex flex-col items-center justify-center text-center px-6 z-10 w-full max-w-5xl mx-auto">
        <div className="w-full animate-fade-in-up">
          <div className="inline-flex items-center gap-2 bg-white/80 border border-blue-100 px-4 py-2 rounded-full text-sm font-semibold text-blue-600 mb-8 shadow-sm backdrop-blur-sm">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-500 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-blue-600"></span>
            </span>
            Decentralized Verification System
          </div>

          <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight leading-tight mb-6 text-slate-900">
            Truth. <br className="hidden md:block" />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-emerald-500">
              Cryptographically Verified.
            </span>
          </h1>

          <p className="text-lg md:text-xl text-slate-500 max-w-2xl mx-auto mb-10 leading-relaxed font-light">
            Instant validation of global health records using advanced blockchain technology and
            IPFS decentralized storage. Transparent, secure, and immutable.
          </p>

          {/* Search Bar */}
          <form onSubmit={handleVerify} className="w-full max-w-xl mx-auto relative group">
            <div className="bg-white p-2 pl-6 flex items-center gap-3 rounded-full shadow-2xl shadow-blue-900/5 border border-slate-100 transition-all focus-within:ring-4 focus-within:ring-blue-500/10 focus-within:border-blue-200">
              <Search
                className="text-slate-400 group-focus-within:text-blue-500 transition-colors"
                size={24}
              />
              <input
                type="text"
                placeholder="Paste IPFS Hash or Transaction Hash..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="flex-1 bg-transparent border-none outline-none text-lg text-slate-800 placeholder:text-slate-400 py-3"
              />
              <button
                type="submit"
                className="bg-slate-900 hover:bg-blue-600 text-white p-4 rounded-full transition-all duration-300 transform hover:scale-105 hover:shadow-lg active:scale-95"
              >
                <ArrowRight size={24} />
              </button>
            </div>
            <div className="mt-4 text-xs font-medium text-slate-400 uppercase tracking-widest">
              Secured by Ethereum & IPFS
            </div>
          </form>

          {/* Advanced Search Toggle */}
          <button
            type="button"
            onClick={() => setShowAdvanced(!showAdvanced)}
            className="mt-6 inline-flex items-center gap-2 text-sm font-medium text-slate-500 hover:text-blue-600 transition-colors"
          >
            <Filter size={16} />
            <span>Advanced Search (Filter by Vaccine & Dose)</span>
            <ChevronDown
              size={16}
              className={`transition-transform ${showAdvanced ? 'rotate-180' : ''}`}
            />
          </button>

          {/* Advanced Search Panel */}
          {showAdvanced && (
            <div className="mt-6 w-full max-w-2xl mx-auto animate-fade-in-up">
              <div className="bg-white rounded-2xl shadow-xl border border-slate-100 p-6">
                <div className="flex items-center justify-between mb-6">
                  <h3 className="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <Syringe size={20} className="text-blue-600" />
                    Verify Specific Vaccination
                  </h3>
                  <button
                    type="button"
                    onClick={() => setShowAdvanced(false)}
                    className="text-slate-400 hover:text-slate-600"
                  >
                    <X size={20} />
                  </button>
                </div>

                <form onSubmit={handleAdvancedSearch} className="space-y-4">
                  {/* Identity Hash Input */}
                  <div>
                    <label className="block text-sm font-semibold text-slate-700 mb-2">
                      Patient Identity Hash <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      placeholder="Enter patient identity hash (SHA-256)"
                      value={advancedSearch.identityHash}
                      onChange={(e) =>
                        setAdvancedSearch((prev) => ({ ...prev, identityHash: e.target.value }))
                      }
                      className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 outline-none transition-all text-slate-800"
                      required
                    />
                  </div>

                  {/* Vaccine Selection */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-semibold text-slate-700 mb-2">
                        Vaccine Type (Optional)
                      </label>
                      <select
                        value={advancedSearch.vaccineSlug}
                        onChange={(e) =>
                          setAdvancedSearch((prev) => ({
                            ...prev,
                            vaccineSlug: e.target.value,
                            doseNumber: '', // Reset dose when vaccine changes
                          }))
                        }
                        className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 outline-none transition-all text-slate-800 bg-white"
                      >
                        <option value="">All Vaccines</option>
                        {VACCINE_OPTIONS.map((vaccine) => (
                          <option key={vaccine.slug} value={vaccine.slug}>
                            {vaccine.name}
                          </option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-semibold text-slate-700 mb-2">
                        Dose Number (Optional)
                      </label>
                      <select
                        value={advancedSearch.doseNumber}
                        onChange={(e) =>
                          setAdvancedSearch((prev) => ({ ...prev, doseNumber: e.target.value }))
                        }
                        className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 outline-none transition-all text-slate-800 bg-white"
                        disabled={!advancedSearch.vaccineSlug}
                      >
                        <option value="">All Doses</option>
                        {Array.from({ length: maxDose }, (_, i) => i + 1).map((dose) => (
                          <option key={dose} value={dose}>
                            Dose {dose}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  {/* Search Button */}
                  <button
                    type="submit"
                    className="w-full bg-gradient-to-r from-blue-600 to-emerald-500 hover:from-blue-700 hover:to-emerald-600 text-white font-semibold py-4 rounded-xl transition-all duration-300 transform hover:scale-[1.02] hover:shadow-lg active:scale-[0.98] flex items-center justify-center gap-2"
                  >
                    <Search size={20} />
                    Verify Vaccination Record
                  </button>

                  <p className="text-xs text-slate-400 text-center">
                    Search by patient identity hash to verify specific vaccine doses from the
                    blockchain
                  </p>
                </form>
              </div>
            </div>
          )}
        </div>
      </main>

      {/* Footer Features */}
      <footer className="px-6 md:px-12 py-10 grid grid-cols-1 md:grid-cols-3 gap-8 md:gap-20 z-10 border-t border-slate-200/60 bg-white/40 backdrop-blur-md">
        <MinimalFeature
          icon={<Shield size={24} className="text-emerald-500" />}
          title="Immutable"
          desc="Tamper-proof records stored permanently on the blockchain."
        />
        <MinimalFeature
          icon={<Globe size={24} className="text-blue-500" />}
          title="Global Standard"
          desc="FHIR compliant data structure interoperable worldwide."
        />
        <MinimalFeature
          icon={<Lock size={24} className="text-amber-500" />}
          title="Privacy Preserving"
          desc="Zero-knowledge proof verification ensures data privacy."
        />
      </footer>

      <style>{`
        @keyframes fadeInUp {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in-up {
          animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
      `}</style>
    </div>
  );
};

const MinimalFeature = ({ icon, title, desc }) => (
  <div className="flex flex-col items-center md:items-start gap-2 text-center md:text-left transition-transform hover:-translate-y-1 duration-300">
    <div className="flex items-center gap-3 font-bold text-slate-800 text-lg">
      {icon}
      <span>{title}</span>
    </div>
    <p className="text-sm text-slate-500 leading-relaxed max-w-xs">{desc}</p>
  </div>
);

export default VerifyLandingPage;
