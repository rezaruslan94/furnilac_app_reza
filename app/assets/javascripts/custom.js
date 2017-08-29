$( document ).ready(function() {
  $('.disable_enter').on('keypress', function(e) {
      return e.which !== 13;
  });
});


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
      return part.text;
      return part.number;
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

  var DisableEnter = field.find('.disable_enter');
  DisableEnter.on('keypress', function(e) {
    return e.which !== 13;
  });

  var dateField = field.find('.dp');
  dateField.datepicker({
    dateFormat: 'dd-mm-yy',
    inline: true
  });

  var DataComboPart = field.find('.ComboPart');
  DataComboPart.select2({
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
      return part.text;
      return part.number;
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
