function check_password(input) {
    if (input.value != document.getElementById('password').value) {
        input.setCustomValidity('Password Must be Matching.');
    } else {
        // input is valid -- reset the error message
        input.setCustomValidity('');
    }
}

function set_valid(id) {
    let icon_element = document.getElementById(id + "-icon");
    let label_element = document.getElementById(id + "-label");

    icon_element.classList.remove('fa-square-xmark')
    icon_element.classList.add('fa-square-check')
    icon_element.style.color = "white"

    label_element.classList.remove('text-muted')
    label_element.style.color = "white"
}
//948b8b

function set_invalid(id) {
    let icon_element = document.getElementById(id + "-icon");
    let label_element = document.getElementById(id + "-label");
    icon_element.classList.remove('fa-square-check')
    icon_element.classList.add('fa-square-xmark')
    icon_element.style.color = "#948b8b"
    label_element.classList.add('text-muted')
}

function validate_password() {
    const password_input = document.getElementById("password");


    // Validate lowercase letters
    const lowerCaseLetters = /[a-z]/g;
    if (password_input.value.match(lowerCaseLetters)) {
        set_valid("condition-0")
    } else {
        set_invalid("condition-0")
    }

    // Validate capital letters
    const upperCaseLetters = /[A-Z]/g;
    if (password_input.value.match(upperCaseLetters)) {
        set_valid("condition-1")
    } else {
        set_invalid("condition-1")
    }

    // Validate numbers
    const numbers = /[0-9]/g;
    if (password_input.value.match(numbers)) {
        set_valid("condition-2")
    } else {
        set_invalid("condition-2")
    }

    // Validate length
    if (password_input.value.length >= 8) {
        set_valid("condition-3")
    } else {
        set_invalid("condition-3")
    }
}

