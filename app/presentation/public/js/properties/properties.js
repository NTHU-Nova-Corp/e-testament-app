open_update_property_modal = (property) => {
    document.getElementById('update-property-id').value = property.id
    document.getElementById('update-name').value = property.name
    document.getElementById('update-description').value = property.description
    document.getElementById('update-property-type-id').value = property.property_type_id
}

open_delete_property_modal = (property) => {
    document.getElementById('delete-title').innerText = `Confirm delete: ${property.name}`
    document.getElementById('delete-property-id').value = property.id
}
