import { Activity, ArrowRight, Globe, Lock, Search, Shield } from 'lucide-react';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const VerifyLandingPage = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const navigate = useNavigate();

  const handleVerify = (e) => {
    e.preventDefault();
    if (searchTerm.trim()) {
      navigate(`/verify/${searchTerm.trim()}`);
    }
  };

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
                placeholder="Paste Transaction Hash or Record ID..."
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
