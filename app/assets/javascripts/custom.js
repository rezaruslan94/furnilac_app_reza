$( document ).ready(function() {
  $(".dp" ).datepicker({
    dateFormat: 'dd-mm-yy',
    inline: true
  });
});

$( document ).ready(function() {
  $(".ComboPart").select2({
    width: '150px',
    placeholder: "Choose a part",
    allowClear: true,
    ajax: {
      url: "/parts/select2",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term, // search term
          page: params.page
        };
      },
      processResults: function (data, params) {
        // parse the results into the format expected by Select2
        // since we are using custom formatting functions we do not need to
        // alter the remote JSON data, except to indicate that infinite
        // scrolling can be used
        params.page = params.page || 1;

        return {
          results: data.items,
          pagination: {
            more: (params.page * 30) < data.total_count
          }
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
    // minimumInputLength: 3,
    templateResult: function(part){
      if (part.loading)
      return
        part.text;
      return part.number
    },
    templateSelection: function(part){
      return part.number || part.text;
    }
  });
});

$( document ).ready(function() {

$('form').on('nested:fieldAdded', function(event) {
  $(event.target).find(':input').enableClientSideValidations();
  var field = event.field;
  //Untuk Add data di form
  field.find('.wh').val($('#area_pics_attributes_0_wh').val());
  console.log("nilai wh di baris pertama = " + $('#area_pics_attributes_0_wh').val());

  field.find('.dp').val($('#area_pics_attributes_0_pic_date').val());
  field.find('.po').val($('#buyer_terminal_fourths_attributes_0_po').val());

  var dateField = field.find('.dp');
  dateField.datepicker({
    dateFormat: 'dd-mm-yy',
    inline: true
  });

  $(".ComboPart").select2({
    width: '150px',
    placeholder: "Choose a part",
    allowClear: true,
    ajax: {
      url: "/parts/select2",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term, // search term
          page: params.page
        };
      },
      processResults: function (data, params) {
        // parse the results into the format expected by Select2
        // since we are using custom formatting functions we do not need to
        // alter the remote JSON data, except to indicate that infinite
        // scrolling can be used
        params.page = params.page || 1;

        return {
          results: data.items,
          pagination: {
            more: (params.page * 30) < data.total_count
          }
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
    minimumInputLength: 3,
    templateResult: function(part){
      if (part.loading)
      return
        part.text;
      return part.number
    },
    templateSelection: function(part){
      return part.number || part.text;
    }
  });

});
});

$( document ).ready(function() {
  $(".ComboEmployee").select2({
    width: '200px',
    placeholder: "Division Employee",
    allowClear: true
  });
});
