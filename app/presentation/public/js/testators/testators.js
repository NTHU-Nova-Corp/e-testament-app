open_release_testament_modal = (testator) => {
  document.getElementById('release-text').innerText = `Are you sure you want to release ${testator.presentation_name}'s testament and send the individual keys to each of the heirs?`
  document.getElementById('form-release-modal').action = `/testators/${testator.id}/release`
}