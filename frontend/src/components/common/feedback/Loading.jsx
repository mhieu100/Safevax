import { SafetyCertificateFilled } from '@ant-design/icons';

const Loading = () => {
  return (
    <div className="fixed inset-0 z-[9999] flex flex-col items-center justify-center bg-slate-50/80 backdrop-blur-sm">
      <div className="relative flex flex-col items-center">
        {}
        <div className="relative mb-8">
          <div className="absolute inset-0 bg-blue-500/20 rounded-full animate-ping" />
          <div className="relative w-20 h-20 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-2xl shadow-xl shadow-blue-500/30 flex items-center justify-center transform hover:scale-105 transition-transform duration-300">
            <SafetyCertificateFilled className="text-4xl text-white" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Loading;
