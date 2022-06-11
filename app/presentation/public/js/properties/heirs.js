open_delete_heir_from_property_modal = (property_heir) => {
    document.getElementById('delete-property-heir-form').action = `/properties/${property_heir.property.id}/heirs/${property_heir.heir.id}/delete`
    document.getElementById('delete-title').innerText = `Confirm Deletion: ${property_heir.heir.first_name} ${property_heir.heir.last_name}`
    document.getElementById('delete-property-id').value = property_heir.property.id
    document.getElementById('delete-heir-id').value = property_heir.heir.id
}

open_update_heir_from_property_modal = (property_heir) => {
    document.getElementById('update-property-heir-form').action = `/properties/${property_heir.property.id}/heirs/${property_heir.heir.id}/update`
    document.getElementById('update-title').innerText = `Update Heir Associated: ${property_heir.heir.first_name} ${property_heir.heir.last_name}`
    document.getElementById('update-property-id').value = property_heir.property.id
    document.getElementById('update-heir-id').value = property_heir.heir.id
    document.getElementById('update-percentage').value = property_heir.percentage
}