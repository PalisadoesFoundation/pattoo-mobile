class FieldValidator{
  static String validateEmail(String value)
  {
    if(value.isEmpty) return 'Enter Email!';

    Pattern pattern =
        "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
            ")+";

    RegExp regex = new RegExp(pattern);

    if(!regex.hasMatch(value)){
      return 'Enter Valid Email!';
    }
    return null;
  }

  static String validatePassword(String value)
  {
    if(value.isEmpty) return 'Enter Password!';

    if(value.length <7)
    {
      return 'Passeord must be more than 6 characters';
    }
    return null;
  }
}