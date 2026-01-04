import {
  ArcElement,
  BarElement,
  CategoryScale,
  Chart as ChartJS,
  Filler,
  Legend,
  LinearScale,
  LineElement,
  PointElement,
  Title,
  Tooltip,
} from 'chart.js';
import { useMemo } from 'react';
import { Bar, Line } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
);

const DashboardCharts = ({ urgentAppointments }) => {
  // 1. Data for Urgency Types (Horizontal Bar)
  const urgencyData = useMemo(() => {
    const counts = {
      NO_DOCTOR: 0,
      RESCHEDULE_PENDING: 0,
      OVERDUE: 0,
      COMING_SOON: 0,
    };

    urgentAppointments.forEach((apt) => {
      if (counts[apt.urgencyType] !== undefined) {
        counts[apt.urgencyType]++;
      }
    });

    return {
      labels: ['Thiếu bác sĩ', 'Yêu cầu đổi lịch', 'Quá hạn xử lý', 'Sắp đến giờ'],
      datasets: [
        {
          label: 'Số lượng hồ sơ',
          data: [counts.NO_DOCTOR, counts.RESCHEDULE_PENDING, counts.OVERDUE, counts.COMING_SOON],
          backgroundColor: [
            '#ef4444', // Red for NO_DOCTOR
            '#a855f7', // Purple for RESCHEDULE
            '#f97316', // Orange for OVERDUE
            '#eab308', // Yellow for COMING_SOON
          ],
          borderRadius: 4,
          barThickness: 20,
        },
      ],
    };
  }, [urgentAppointments]);

  const barOptions = {
    indexAxis: 'y', // Horizontal bar
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: '#1e293b',
        padding: 12,
        titleFont: { family: "'Inter', sans-serif", size: 13 },
        bodyFont: { family: "'Inter', sans-serif", size: 13 },
        displayColors: false,
      },
    },
    scales: {
      x: {
        beginAtZero: true,
        grid: { display: false },
        ticks: { stepSize: 1, font: { family: "'Inter', sans-serif" }, color: '#94a3b8' },
        border: { display: false },
      },
      y: {
        grid: { display: false },
        ticks: { font: { family: "'Inter', sans-serif", weight: 500 }, color: '#475569' },
        border: { display: false },
      },
    },
  };

  // 2. Mock Data for Weekly Activity (Line Chart)
  // Focusing on "Performance" contexts
  const weeklyData = {
    labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
    datasets: [
      {
        label: 'Đã xử lý',
        data: [45, 52, 38, 65, 48, 60, 40],
        borderColor: '#3b82f6', // Blue
        backgroundColor: (context) => {
          const ctx = context.chart.ctx;
          const gradient = ctx.createLinearGradient(0, 0, 0, 300);
          gradient.addColorStop(0, 'rgba(59, 130, 246, 0.2)');
          gradient.addColorStop(1, 'rgba(59, 130, 246, 0)');
          return gradient;
        },
        fill: true,
        tension: 0.4,
        pointRadius: 3,
        pointBackgroundColor: '#ffffff',
        pointBorderColor: '#3b82f6',
        pointBorderWidth: 2,
      },
    ],
  };

  const lineOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: '#1e293b',
        padding: 12,
        titleFont: { family: "'Inter', sans-serif", size: 13 },
        bodyFont: { family: "'Inter', sans-serif", size: 13 },
        displayColors: false,
        callbacks: {
          label: (context) => `${context.parsed.y} hồ sơ`,
        },
      },
    },
    scales: {
      x: {
        grid: { display: false },
        ticks: { font: { family: "'Inter', sans-serif" }, color: '#94a3b8' },
        border: { display: false },
      },
      y: {
        grid: { color: '#f1f5f9', borderDash: [5, 5] },
        ticks: { font: { family: "'Inter', sans-serif" }, color: '#94a3b8', stepSize: 20 },
        border: { display: false },
        beginAtZero: true,
      },
    },
    interaction: {
      mode: 'index',
      intersect: false,
    },
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
      {/* Line Chart: Overall Performance */}
      <div className="lg:col-span-2 bg-white p-6 rounded-xl shadow-sm border border-slate-100">
        <div className="flex justify-between items-center mb-6">
          <h3 className="text-slate-700 font-semibold flex items-center gap-2 m-0">
            <span className="w-2 h-6 bg-blue-500 rounded-full"></span>
            Hiệu suất xử lý tuần này
          </h3>
          <div className="text-right">
            <span className="text-xs text-slate-400 block">Tổng hồ sơ đã xử lý</span>
            <span className="text-xl font-bold text-slate-700">348</span>
          </div>
        </div>
        <div className="h-[250px]">
          <Line data={weeklyData} options={lineOptions} />
        </div>
      </div>

      {/* Bar Chart: Urgency Analysis */}
      <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
        <div className="flex justify-between items-center mb-6">
          <h3 className="text-slate-700 font-semibold flex items-center gap-2 m-0">
            <span className="w-2 h-6 bg-red-500 rounded-full"></span>
            Vấn đề cần tập trung
          </h3>
        </div>
        <div className="h-[250px]">
          {urgentAppointments.length === 0 ? (
            <div className="h-full flex flex-col items-center justify-center text-slate-400">
              <span className="text-4xl mb-2">🎉</span>
              <span className="text-sm">Không có vấn đề cần xử lý</span>
            </div>
          ) : (
            <Bar data={urgencyData} options={barOptions} />
          )}
        </div>
      </div>
    </div>
  );
};

export default DashboardCharts;
