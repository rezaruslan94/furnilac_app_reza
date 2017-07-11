$(document).ready(function() {
  $('#TwhDataTables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#TwhDataTables').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      { "orderable": false, "targets": [3] }
    ]
  });
});

$(document).ready(function() {
  $('#EmployeeDatatables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#EmployeeDatatables').data('source'),
    "pagingType": "full_numbers"
  });
});

$(document).ready(function() {
  $('#TerminalFourthDatatables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#TerminalFourthDatatables').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      { "orderable": false, "targets": [4,7,8,9] }
    ]
  });
});

$(document).ready(function() {
  $('#PicDataTables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#PicDataTables').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      { "orderable": false, "targets": [5,6] }
    ]
  });
});

$(document).ready(function() {
  $('#DivisionDataTables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#DivisionDataTables').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      { "orderable": false, "targets": [3,4] }
    ]
  });
});
