// 取得今天的日期
const today = new Date();

// 取得今天是一周中的星期幾（0代表星期日，1代表星期一，以此類推）
const dayOfWeek = today.getDay();

// 計算本週的星期日的日期
const sunday = new Date(today);
sunday.setDate(today.getDate() - dayOfWeek);

// 建立一周的日期
const weekDates = [];
for (let i = 0; i < 7; i++) {
  const date = new Date(sunday);
  date.setDate(sunday.getDate() + i);
  weekDates.push(date);
}

// 將日期格式化為英文縮寫的星期幾
function formatDayOfWeek(date) {
  const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return daysOfWeek[date.getDay()];
}

// 將日期格式化為 "月份/日期" 的形式
function formatDate(date) {
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${month}/${day}`;
}

// 在HTML中顯示一周的日期
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
