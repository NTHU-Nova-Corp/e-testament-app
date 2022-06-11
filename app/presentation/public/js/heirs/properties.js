open_delete_property_from_heir_modal = (property_heir) => {
  document.getElementById('delete-property-heir-form').action = `/heirs/${property_heir.heir.id}/properties/${property_heir.property.id}/delete`
  document.getElementById('delete-title').innerText = `Confirm Deletion: ${property_heir.property.name}`
  document.getElementById('delete-property-id').value = property_heir.property.id
  document.getElementById('delete-heir-id').value = property_heir.heir.id
}

open_update_property_from_heir_modal = (property_heir) => {
  document.getElementById('update-property-heir-form').action = `/heirs/${property_heir.heir.id}/properties/${property_heir.property.id}/update`
  document.getElementById('update-title').innerText = `Update Property Associated: ${property_heir.property.name}`
  document.getElementById('update-property-id').value = property_heir.property.id
  document.getElementById('update-heir-id').value = property_heir.heir.id
  document.getElementById('update-percentage').value = property_heir.percentage
}