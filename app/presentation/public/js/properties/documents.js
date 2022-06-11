open_delete_document_from_property_modal = (property_document) => {
  document.getElementById('delete-property-document-form').action = `/properties/${property_document.property_id}/documents/${property_document.id}/delete`
  document.getElementById('delete-title').innerText = `Confirm Deletion: ${property_document.file_name}`
  document.getElementById('delete-property-id').value = dproperty_documentocument.property.id
  document.getElementById('delete-document-id').value = property_document.id
}

open_update_document_from_property_modal = (property_document) => {
  document.getElementById('update-property-document-form').action = `/properties/${property_document.property.id}/documents/${property_document.document.id}/update`
  document.getElementById('update-title').innerText = `Update document Associated: ${property_document.document.first_name} ${property_document.document.last_name}`
  document.getElementById('update-property-id').value = property_document.property.id
  document.getElementById('update-document-id').value = property_document.document.id
  document.getElementById('update-percentage').value = property_document.percentage
}