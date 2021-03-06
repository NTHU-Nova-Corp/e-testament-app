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

createAndDownloadBlobFile = (file_name, content) => {
  const binaryString = atob(content); // Comment this if not using base64
  const bytes = new Uint8Array(binaryString.length);
  body = bytes.map((byte, i) => binaryString.charCodeAt(i));

  const blob = new Blob([body]);
  const link = document.createElement("a");

  // Browsers that support HTML5 download attribute
  if (link.download !== undefined) {
    const url = URL.createObjectURL(blob);
    link.setAttribute("href", url);
    link.setAttribute("download", file_name);
    link.style.visibility = "hidden";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}