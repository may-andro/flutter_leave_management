class CompanyLeave{


  String title;
  String date;

  CompanyLeave(this.title, this.date);

  CompanyLeave.fromJson(this.title, Map data) {
    date = data['date'];
    if (date == null) {
      date = '';
    }
  }

}