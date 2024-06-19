function app() {
    return {
        month: '',
        year: '',
        no_of_days: [],
        blankdays: [],
        days_in_month: [],
        days_of_week: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        events: [],
        MONTH_NAMES: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        DAYS: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        colors: ['blue', 'red', 'yellow', 'green', 'purple'], // List of colors

        initDate() {
            let today = new Date();
            this.month = today.getMonth();
            this.year = today.getFullYear();
            this.getNoOfDays();
        },

        isHoliday(year, month, date) {
            let holidays = [
                new Date(year, 0, 1), // New Year
                new Date(year, 11, 25), // Christmas
            ];
            return holidays.some(holiday => holiday.getTime() === new Date(year, month, date).getTime());
        },

        isToday(date) {
            const today = new Date();
            const d = new Date(this.year, this.month, date);
            return today.toDateString() === d.toDateString();
        },

        goToToday() {
            this.initDate();
        },

        showEventModal(date) {
            // Show event modal for the selected date (functionality can be expanded as needed)
        },

        addEvent(event) {
            const startDate = new Date(event.start_date);
            const endDate = new Date(event.end_date);
            let currentDate = startDate;

            // Get a random color for the event
            const randomColor = this.colors[Math.floor(Math.random() * this.colors.length)];

            while (currentDate <= endDate) {
                this.events.push({
                    event_date: new Date(currentDate),
                    event_title: event.event_title,
                    event_theme: randomColor,
                });
                currentDate.setDate(currentDate.getDate() + 1);
            }
        },

        getNoOfDays() {
            let days_in_month = new Date(this.year, this.month + 1, 0).getDate();

            // find where to start calendar day of week
            let day_of_week = new Date(this.year, this.month).getDay();

            let blankdaysArray = [];
            for ( var i=1; i <= day_of_week; i++) {
                blankdaysArray.push(i);
            }

            let daysArray = [];
            for ( var i=1; i <= days_in_month; i++) {
                daysArray.push(i);
            }

            this.blankdays = blankdaysArray;
            this.no_of_days = daysArray;
        },
    }
}

document.addEventListener('alpine:init', () => {
    Alpine.data('app', app);
});

document.getElementById('taskForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const event = {
        event_title: formData.get('name'),
        start_date: formData.get('startDate'),
        end_date: formData.get('endDate'),
        event_theme: 'blue' // You can add a dropdown for theme selection in the form if needed
    };

    document.querySelector('[x-data="app()"]').__x.$data.addEvent(event);
    document.querySelector('[data-modal-toggle="crud-modal"]').click(); // Close the modal
});
