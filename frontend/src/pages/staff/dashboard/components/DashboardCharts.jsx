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
import { Doughnut, Line } from 'react-chartjs-2';
import { useTranslation } from 'react-i18next';

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

const DashboardCharts = ({ stats }) => {
  const { t } = useTranslation(['staff']);

  // 1. Data for Appointment Status (Doughnut)
  const appointmentStatusData = useMemo(() => {
    let completed = stats?.weekCompleted || 0;
    let cancelled = stats?.weekCancelled || 0;

    // TODO: Mock data for demonstration if empty
    if (completed === 0 && cancelled === 0) {
      completed = 85;
      cancelled = 15;
    }

    return {
      labels: [t('staff:dashboard.charts.completed'), t('staff:dashboard.charts.cancelled')],
      datasets: [
        {
          data: [completed, cancelled],
          backgroundColor: ['#10b981', '#ef4444'], // Green for Completed, Red for Cancelled
          borderWidth: 0,
          hoverBackgroundColor: ['#10b981', '#ef4444'],
        },
      ],
    };
  }, [stats, t]);

  const doughnutOptions = {
    responsive: true,
    maintainAspectRatio: false,
    cutout: '70%',
    plugins: {
      legend: {
        position: 'bottom',
        display: true,
        labels: {
          font: { family: "'Inter', sans-serif", size: 12 },
          usePointStyle: true,
          padding: 20,
        },
      },
      tooltip: {
        backgroundColor: '#1e293b',
        padding: 12,
        titleFont: { family: "'Inter', sans-serif", size: 13 },
        bodyFont: { family: "'Inter', sans-serif", size: 13 },
        displayColors: false,
        callbacks: {
          label: (context) =>
            ` ${context.label}: ${context.parsed} ${t('staff:dashboard.charts.cases')}`,
        },
      },
    },
  };

  // 2. Mock Data for Weekly Activity (Line Chart)
  // Focusing on "Performance" contexts
  const weeklyData = {
    labels: [
      t('staff:common.calendar.mon'),
      t('staff:common.calendar.tue'),
      t('staff:common.calendar.wed'),
      t('staff:common.calendar.thu'),
      t('staff:common.calendar.fri'),
      t('staff:common.calendar.sat'),
      t('staff:common.calendar.sun'),
    ],
    datasets: [
      {
        label: t('staff:dashboard.charts.processed'),
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
          label: (context) => `${context.parsed.y} ${t('staff:dashboard.charts.cases')}`,
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
            {t('staff:dashboard.charts.weeklyPerformance')}
          </h3>
          <div className="text-right">
            <span className="text-xs text-slate-400 block">
              {t('staff:dashboard.charts.totalProcessed')}
            </span>
            <span className="text-xl font-bold text-slate-700">348</span>
          </div>
        </div>
        <div className="h-[250px]">
          <Line data={weeklyData} options={lineOptions} />
        </div>
      </div>

      {/* Doughnut Chart: Appointment Status */}
      <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
        <div className="flex justify-between items-center mb-6">
          <h3 className="text-slate-700 font-semibold flex items-center gap-2 m-0">
            <span className="w-2 h-6 bg-emerald-500 rounded-full"></span>
            {t('staff:dashboard.charts.appointmentStatus')}
          </h3>
        </div>
        <div className="h-[250px] flex items-center justify-center">
          <Doughnut data={appointmentStatusData} options={doughnutOptions} />
        </div>
      </div>
    </div>
  );
};

export default DashboardCharts;
