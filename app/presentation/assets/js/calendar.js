function app() {
    return {
        month: '',
        year: '',
        no_of_days: [],
        blankdays: [],
        days_in_month: [],
        days_of_week: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        events: [],
        colors: ['blue', 'red', 'yellow', 'green', 'purple'], // List of colors
        MONTH_NAMES: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        DAYS: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],

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

        addEvent(eventTitle, startDate, endDate, eventUrl = '#') {
            const start = new Date(startDate);
            const end = new Date(endDate);
            let currentDate = new Date(start);

            let colorIndex = this.events.length % this.colors.length;
            const eventColor = this.colors[colorIndex];

            while (currentDate <= end) {
                this.events.push({
                    event_date: new Date(currentDate),
                    event_title: eventTitle,
                    event_theme: eventColor,
                    event_url: eventUrl, // Include the event URL
                });
                currentDate.setDate(currentDate.getDate() + 1);

                colorIndex = (colorIndex + 1) % this.colors.length;
            }
        },

        getNoOfDays() {
            let days_in_month = new Date(this.year, this.month + 1, 0).getDate();

            // find where to start calendar day of week
            let day_of_week = new Date(this.year, this.month).getDay();

            let blankdaysArray = [];
            for (var i = 1; i <= day_of_week; i++) {
                blankdaysArray.push(i);
            }

            let daysArray = [];
            for (var i = 1; i <= days_in_month; i++) {
                daysArray.push(i);
            }

            this.blankdays = blankdaysArray;
            this.no_of_days = daysArray;
        },

        truncateTitle(title, length = 10) {
            return title.length > length ? title.substring(0, length) + '...' : title;
        }
    };
}

document.addEventListener('alpine:init', () => {
    Alpine.data('app', app);
});

document.addEventListener("DOMContentLoaded", function () {
    const events = {
        "event1": ["test1", "2024-06-19 21:47:00 +0800", "2024-06-19 22:47:00 +0800", "https://example.com/event1"],
        "event2": ["test2", "2024-06-21 21:27:00 +0800", "2024-06-22 21:27:00 +0800", "https://example.com/event2"],
        "event3": ["You upload?", "2024-06-21 21:40:00 +0800", "2024-06-22 21:40:00 +0800", "https://example.com/event3"],
        "event4": ["test3", "2024-06-19 09:58:00 +0800", "2024-06-25 21:59:00 +0800", "https://example.com/event4"],
        "event5": ["test4", "2024-06-19 02:24:00 +0800", "2024-07-20 04:25:00 +0800", "https://example.com/event5"],
        "event6": ["test5", "2024-06-19 02:24:00 +0800", "2024-07-20 04:25:00 +0800", "https://example.com/event6"],
        "event7": ["test6", "2024-06-19 02:24:00 +0800", "2024-07-20 04:25:00 +0800", "https://example.com/event7"]
    };

    const appInstance = document.querySelector('[x-data="app()"]').__x.$data;

    // Iterate over events and assign colors sequentially
    let colorIndex = 0;
    for (const eventKey in events) {
        const event = events[eventKey];
        const eventTitle = event[0];
        const startDate = event[1];
        const endDate = event[2];
        const eventUrl = event[3];
        appInstance.addEvent(eventTitle, startDate, endDate, eventUrl);
        colorIndex++;
    }

    document.querySelector('[data-modal-toggle="crud-modal"]').click(); // Close the modal if needed
});
