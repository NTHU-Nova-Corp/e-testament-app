open_update_heir_modal = (heir) => {
    document.getElementById('update-heir-id').value = heir.id
    document.getElementById('update-first-name').value = heir.first_name
    document.getElementById('update-last-name').value = heir.last_name
    document.getElementById('update-email').value = heir.email
    document.getElementById('update-relation-id').value = heir.relation_id
}

open_delete_heir_modal = (heir) => {
    document.getElementById('delete-title').innerText = `Confirm delete : ${heir.first_name} ${heir.last_name}`
    document.getElementById('delete-heir-id').value = heir.id
}
