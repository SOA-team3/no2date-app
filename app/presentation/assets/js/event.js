document.addEventListener("DOMContentLoaded", function() {
    let currentRowId = null;

    document.querySelectorAll('.deleteButton').forEach(button => {
        button.addEventListener('click', function(event) {
            event.preventDefault();
            currentRowId = this.closest('tr').getAttribute('data-row-id');
            document.getElementById('confirmDeleteModal').classList.remove('hidden');
        });
    });

    document.getElementById('closeModal').addEventListener('click', function() {
        document.getElementById('confirmDeleteModal').classList.add('hidden');
    });

    document.getElementById('cancelModal').addEventListener('click', function() {
        document.getElementById('confirmDeleteModal').classList.add('hidden');
    });

    document.getElementById('confirmDelete').addEventListener('click', function() {
        if (currentRowId) {
            const row = document.querySelector(`tr[data-row-id="${currentRowId}"]`);
            if (row) {
                row.remove();
            }
            currentRowId = null;
            document.getElementById('confirmDeleteModal').classList.add('hidden');
        }
    });
});


//checks if the start date time is less than the end date time


document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('new-event-form').addEventListener('submit', function(event) {
        const startDateTime = document.getElementById('start_datetime').value;
        const endDateTime = document.getElementById('end_datetime').value;
        if (new Date(startDateTime) >= new Date(endDateTime)) {
            alert('Start DateTime must be earlier than End DateTime');
            event.preventDefault();
        }
    });
});