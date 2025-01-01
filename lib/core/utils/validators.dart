// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import 'extensions.dart';

class Validator {
  Validator._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório!';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'Entre um e-mail válido!';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password é obrigatório!';
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');
    if (!regex.hasMatch(value)) {
      return 'Senha deve ser 6+ caracteres com letras e números!';
    }
    return null;
  }

  static String? checkPassword(String? password, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password é obrigatório!';
    }
    if (password != value) {
      return 'As senhas são diferentes!';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.length < 3) {
      return 'Um nome/apelido é obrigatório!';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    // Remove any characters that are not numbers
    final phone = value.onlyNumbers();

    // Check if the phone number length is valid
    if (phone.length != 11 && phone.length != 10) {
      return 'Número de telefone inválido';
    }

    // Check if the area code is in the correct range (11 to 99)
    final areaCode = int.parse(phone.substring(0, 2));
    if (areaCode < 11) {
      return 'Número de telefone inválido';
    }

    // Check if it is a valid mobile number (starts with 9 if it has 11 digits)
    if (phone.length == 11 && phone[2] != '9') {
      return 'Número de celular inválido';
    }

    // Check if it is a valid landline number (starts with something other than
    // 9 if it has 10 digits)
    if (phone.length == 10 && phone[2] == '9') {
      return 'Número de celular inválido';
    }

    return null;
  }

  // Sales Validators
  static String? title(String? value) {
    if (value == null || value.length < 3) {
      return 'Título é obrigatório e deve ser maior que 3 caracteres';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null) {
      return 'Descrição é obrigatório.';
    } else if (value.length < 20) {
      return 'Ao menos 20 caracteres. Detalhe o estado do produto.';
    }
    return null;
  }

  static String? mechanics(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecione alguma mecânica.';
    }
    return null;
  }

  static String? address(String? value) {
    if (value == null) {
      return 'Endereço é obrigatório';
    }
    if (value.isEmpty || value.length < 8) {
      return 'Endereço inválido';
    }
    return null;
  }

  static String? zipCode(String? value) {
    if (value == null) {
      return 'CEP é obrigatório';
    }
    final cleanCode = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanCode.length < 8) {
      return 'CEP inválido';
    }
    return null;
  }

  static String? cust(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preço é obrigatório';
    }
    return null;
  }
}

class AddressValidator {
  static get zipCode => Validator.zipCode;

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tipo de endereço é obrigatório!';
    } else if (value.length < 3) {
      return 'Tipo de endereço dever 3 ou mais caracteres!';
    }
    return null;
  }

  static String? street(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rua/Av é obrigatório!';
    } else if (value.length < 3) {
      return 'Tipo de endereço dever 3 ou mais caracteres!';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número é obrigatório!';
    }
    return null;
  }

  static String? neighborhood(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bairro é obrigatório!';
    }
    return null;
  }

  static String? state(String? value) {
    if (value == null || value.isEmpty) {
      return 'Estado é obrigatório!';
    }
    return null;
  }

  static String? city(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cidade é obrigatório!';
    }
    return null;
  }
}

class DataValidator {
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');
    if (!regex.hasMatch(value)) {
      return 'Senha deve ser 6+ caracteres com letras e números!';
    }
    return null;
  }

  static String? checkPassword(String? password, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (password != value) {
      return 'As senhas são diferentes!';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length < 3) {
      return 'Nome deve ter 3 ou mais cadacteres';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Remove any characters that are not numbers
    final phone = value.onlyNumbers();

    // Check if the phone number length is valid
    if (phone.length != 11 && phone.length != 10) {
      return 'Número de telefone inválido';
    }

    // Check if the area code is in the correct range (11 to 99)
    final areaCode = int.parse(phone.substring(0, 2));
    if (areaCode < 11) {
      return 'Número de telefone inválido';
    }

    // Check if it is a valid mobile number (starts with 9 if it has 11 digits)
    if (phone.length == 11 && phone[2] != '9') {
      return 'Número de celular inválido';
    }

    // Check if it is a valid landline number (starts with something other than
    // 9 if it has 10 digits)
    if (phone.length == 10 && phone[2] == '9') {
      return 'Número de celular inválido';
    }

    return null;
  }
}
