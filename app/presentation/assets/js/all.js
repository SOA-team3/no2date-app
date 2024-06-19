// Get today's date
const today = new Date();

// 取得今天是一周中的星期幾（0代表星期日，1代表星期一，以此類推）
const dayOfWeek = today.getDay();

// Calculate Sunday's date
const sunday = new Date(today);
sunday.setDate(today.getDate() - dayOfWeek);

// Create one week's dates
const weekDates = [];
for (let i = 0; i < 7; i++) {
  const date = new Date(sunday);
  date.setDate(sunday.getDate() + i);
  weekDates.push(date);
}

// Change date format into abbr
function formatDayOfWeek(date) {
  const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return daysOfWeek[date.getDay()];
}

// Change datetime format into mm/dd
function formatDate(date) {
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${month}/${day}`;
}

// Show dates in one week
const weekDatesContainer = document.getElementById("week-dates");
weekDates.forEach(date => {
  const formattedDate = formatDate(date);
  const formattedDayOfWeek = formatDayOfWeek(date);
  const isActive = date.getDate() === today.getDate() ? 'bg-blue-300 shadow-lg dark-shadow' : '';
  const textColor = date.getDate() === today.getDate() ? 'text-blue-900 group-hover:text-gray-100' : 'text-gray-900 group-hover:text-gray-100';
  weekDatesContainer.innerHTML += `
    <div class='flex group hover:bg-sky-300 hover:shadow-lg hover-dark-shadow rounded-full mx-1 transition-all duration-300 cursor-pointer justify-center w-16 ${isActive}'>
      <div class='flex items-center px-4 py-4'>
        <div class='text-center'>
          <p class='${textColor} text-sm transition-all group-hover:font-semibold duration-300'> ${formattedDayOfWeek} </p>
          <p class='${textColor} mt-3 group-hover:font-bold transition-all duration-300'> ${formattedDate} </p>
        </div>
      </div>
    </div>
  `;
});

