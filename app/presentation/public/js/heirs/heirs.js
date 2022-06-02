open_update_heir_modal = (heir) => {
    document.getElementById('update-heir-id').value = heir.id
    document.getElementById('update-name').value = heir.name
    document.getElementById('update-description').value = heir.description
    document.getElementById('update-relation_id').value = heir.relation_id
}

open_delete_heir_modal = (heir) => {
    document.getElementById('delete-title').innerText = `Confirm delete : ${heir.name}`
    document.getElementById('delete-heir-id').value = heir.id
}
