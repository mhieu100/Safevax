import {
  Activity,
  BadgeCheck,
  Building2,
  Calendar,
  Download,
  ShieldCheck,
  Syringe,
} from 'lucide-react';
import { QRCodeCanvas } from 'qrcode.react';

const VerificationCard = ({ data, onViewPassport }) => {
  if (!data) return null;

  return (
    <div className="w-full max-w-[500px] bg-white rounded-3xl overflow-hidden shadow-2xl ring-1 ring-slate-900/5 font-sans relative">
      {/* Top Security Bar */}
      <div className="bg-slate-900 h-9 flex items-center justify-between px-4">
        <div className="w-16 h-1 bg-[repeating-linear-gradient(90deg,#334155,#334155_4px,transparent_4px,transparent_8px)]" />
        <div className="flex items-center gap-1.5 text-[0.65rem] font-bold text-emerald-400 tracking-widest">
          <ShieldCheck size={14} className="text-emerald-400" />
          <span>SECURE VERIFICATION</span>
        </div>
      </div>

      <div className="p-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center gap-4 mb-6 relative">
          <div className="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center shrink-0">
            <Activity size={24} className="text-blue-600" />
          </div>
          <div className="flex-1">
            <h1 className="text-lg font-extrabold text-slate-900 leading-tight">
              DIGITAL HEALTH PASS
            </h1>
            <div className="text-[0.65rem] text-slate-500 font-semibold tracking-wide">
              BLOCKCHAIN VERIFIED
            </div>
          </div>
          <div className="self-start sm:self-center ml-auto border-2 border-blue-500/20 bg-blue-500/5 rounded-full px-3 py-1 flex items-center gap-1.5 text-xs font-bold text-blue-600">
            <BadgeCheck size={14} className="fill-blue-600 text-white" />
            <span>VALID</span>
          </div>
        </div>

        {/* Patient Info Grid */}
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-end gap-6 mb-8 group">
          <div className="flex-1 w-full sm:w-auto">
            <label className="text-[0.6rem] font-bold text-slate-400 block mb-1 tracking-widest uppercase">
              BENEFICIARY
            </label>
            <div className="text-2xl font-bold text-slate-900 mb-2 break-words">
              {data.patientName}
            </div>
            <div className="font-mono text-xs text-slate-500 bg-slate-50 px-2 py-1 rounded inline-block border border-slate-100 break-all">
              ID: {data.patientIdentityHash?.substring(0, 10)}...
              {data.patientIdentityHash?.substring(data.patientIdentityHash.length - 4)}
            </div>
          </div>

          <div className="p-1.5 border-2 border-dashed border-slate-200 rounded-xl bg-white self-center sm:self-end shrink-0 transition-all group-hover:border-blue-200 group-hover:shadow-lg">
            <QRCodeCanvas
              value={`${window.location.origin}/verify/${data.ipfsHash}`}
              size={80}
              level={'H'}
              className="rounded-lg"
            />
          </div>
        </div>

        <div className="h-px bg-slate-100 w-full mb-6 relative">
          <div className="absolute top-0 left-0 w-10 h-0.5 bg-blue-500" />
        </div>

        {/* Vaccine Details - Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-6 mb-6">
          <div>
            <label className="text-[0.6rem] font-bold text-slate-400 block mb-1 tracking-widest uppercase flex items-center gap-1">
              <Syringe size={10} /> VACCINE PROPHYLAXIS
            </label>
            <div className="text-sm font-semibold text-slate-700">{data.vaccineName}</div>
          </div>
          <div>
            <label className="text-[0.6rem] font-bold text-slate-400 block mb-1 tracking-widest uppercase">
              MANUFACTURER
            </label>
            <div className="text-sm font-semibold text-slate-700">{data.manufacturer}</div>
          </div>
          <div>
            <label className="text-[0.6rem] font-bold text-slate-400 block mb-1 tracking-widest uppercase">
              DOSE / TOTAL
            </label>
            <div className="text-sm font-bold text-blue-600 bg-blue-50 inline-block px-2 py-0.5 rounded-md">
              {data.doseNumber} / {data.dosesRequired || 2}
            </div>
          </div>
          <div>
            <label className="text-[0.6rem] font-bold text-slate-400 block mb-1 tracking-widest uppercase flex items-center gap-1">
              <Calendar size={10} /> DATE OF VACCINATION
            </label>
            <div className="text-sm font-semibold text-slate-700">{data.vaccinationDate}</div>
          </div>
        </div>

        <div className="mb-6 bg-slate-50 p-3 rounded-lg border border-slate-100">
          <label className="text-[0.6rem] font-bold text-slate-400 block mb-1 tracking-widest uppercase flex items-center gap-1">
            <Building2 size={10} /> ISSUING CENTER
          </label>
          <div className="text-sm font-semibold text-slate-800 break-words">{data.centerName}</div>
        </div>
      </div>

      {data.patientIdentityHash && (
        <div className="px-6 py-4 bg-blue-50/50 border-t border-slate-100 flex items-center justify-between">
          <span className="text-xs font-medium text-slate-500">
            More records found for this identity
          </span>
          <button
            onClick={onViewPassport}
            className="text-xs font-bold text-blue-600 hover:text-blue-700 hover:underline flex items-center gap-1 transition-colors pointer-events-auto"
          >
            View Full Passport <Activity size={12} />
          </button>
        </div>
      )}

      {/* Blockchain Footer */}
      <div className="bg-slate-900 p-4 space-y-2">
        <div className="flex items-center gap-2 text-slate-400 font-mono text-[0.65rem] break-all">
          <Download size={12} className="text-blue-500 shrink-0" />
          <span>IPFS: {data.ipfsHash?.substring(0, 20)}...</span>
        </div>
        <div className="flex items-center gap-2 text-slate-400 font-mono text-[0.65rem] break-all">
          <Activity size={12} className="text-emerald-500 shrink-0" />
          <span>TX: {data.transactionHash?.substring(0, 20)}...</span>
        </div>
      </div>
    </div>
  );
};

export default VerificationCard;
