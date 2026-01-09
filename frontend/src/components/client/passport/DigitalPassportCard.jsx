import { Activity, CheckCircle2, Copy, ShieldCheck } from 'lucide-react';
import { QRCodeCanvas } from 'qrcode.react';

const DigitalPassportCard = ({ user, identityHash, qrUrl }) => {
  return (
    <div className="relative w-full max-w-[420px] mx-auto min-h-[260px] rounded-[24px] overflow-hidden shadow-2xl transition-transform hover:scale-[1.02] duration-300 group">
      {/* Background with Glassmorphism and Gradients */}
      <div className="absolute inset-0 bg-gradient-to-br from-slate-900 via-slate-800 to-blue-900">
        {/* Animated Orbs */}
        <div className="absolute top-[-50%] left-[-20%] w-[80%] h-[80%] rounded-full bg-blue-500/20 blur-3xl animate-pulse" />
        <div className="absolute bottom-[-20%] right-[-20%] w-[60%] h-[60%] rounded-full bg-emerald-500/10 blur-3xl animate-pulse delay-1000" />

        {/* Tech Grid Pattern */}
        <div className="absolute inset-0 opacity-[0.05] bg-[linear-gradient(to_right,#ffffff_1px,transparent_1px),linear-gradient(to_bottom,#ffffff_1px,transparent_1px)] bg-[size:32px_32px]" />
      </div>

      {/* Glass Overlay */}
      <div className="absolute inset-0 bg-white/5 backdrop-blur-[2px] border border-white/10 rounded-[24px]" />

      {/* Content Container */}
      <div className="relative h-full flex flex-col p-6 z-10 text-white">
        {/* Header */}
        <div className="flex justify-between items-start mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center shadow-lg shadow-blue-500/30">
              <ShieldCheck className="text-white w-6 h-6" />
            </div>
            <div>
              <div className="text-[10px] uppercase tracking-widest text-blue-200 font-bold opacity-80">
                SafeVax Protocol
              </div>
              <div className="text-lg font-bold leading-none tracking-tight">Digital Passport</div>
            </div>
          </div>

          <div className="bg-emerald-500/20 border border-emerald-500/30 rounded-full px-3 py-1 flex items-center gap-1.5 backdrop-blur-md">
            <CheckCircle2 size={12} className="text-emerald-400" />
            <span className="text-[10px] font-bold text-emerald-100 tracking-wide uppercase">
              Verified
            </span>
          </div>
        </div>

        {/* Middle Section: User Info & QR */}
        <div className="flex flex-1 items-center gap-6 mt-1">
          {/* QR Code Area */}
          <div className="relative group/qr p-3 bg-white rounded-2xl shadow-xl">
            <QRCodeCanvas
              value={qrUrl || 'https://safevax.com'}
              size={110}
              level="H"
              bgColor="#FFFFFF"
              fgColor="#0F172A"
              className="rounded-lg"
            />
            <div className="absolute inset-0 rounded-2xl ring-2 ring-blue-500/20 group-hover/qr:ring-blue-400/50 transition-all pointer-events-none" />
          </div>

          {/* User Details */}
          <div className="flex-1 flex flex-col justify-center gap-4">
            <div>
              <label className="text-[10px] uppercase tracking-widest text-slate-400 font-bold mb-1 block">
                Beneficiary Name
              </label>
              <div className="text-xl font-bold text-white leading-tight truncate">
                {user?.fullName || 'Unknown User'}
              </div>
            </div>

            <div>
              <label className="text-[10px] uppercase tracking-widest text-slate-400 font-bold mb-1 block">
                Identity Hash
              </label>
              <div className="group/hash relative flex items-center gap-2">
                <div className="font-mono text-[11px] text-blue-100/90 bg-blue-950/40 px-2 py-1.5 rounded-lg border border-blue-500/20 truncate max-w-[140px]">
                  {identityHash
                    ? `${identityHash.substring(0, 10)}...${identityHash.substring(identityHash.length - 4)}`
                    : 'Generating...'}
                </div>
                {identityHash && (
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      navigator.clipboard.writeText(identityHash);
                    }}
                    className="p-1.5 rounded-lg hover:bg-white/10 text-slate-400 hover:text-white transition-colors"
                  >
                    <Copy size={12} />
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-6 pt-4 border-t border-white/10 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
            <span className="text-[10px] font-mono text-slate-400">NODE STATUS: CONNECTED</span>
          </div>

          <div className="flex items-center gap-1 opacity-50">
            <Activity size={14} className="text-blue-400" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default DigitalPassportCard;
