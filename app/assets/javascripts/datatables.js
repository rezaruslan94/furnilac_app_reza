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
  $('#EmployeeDataTables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#EmployeeDataTables').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      { "orderable": false, "targets": [1,2] }
    ]
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
      { "orderable": false, "targets": [3] }
    ]
  });
});

$(document).ready(function() {
  $('#ItemDataTables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#ItemDataTables').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      { "orderable": false, "targets": [1] }
    ]
  });
});

$(document).ready(function() {
  $('#PartDataTables').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#PartDataTables').data('source'),
    "pagingType": "full_numbers"
  });
});
