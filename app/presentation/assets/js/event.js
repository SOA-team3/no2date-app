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
