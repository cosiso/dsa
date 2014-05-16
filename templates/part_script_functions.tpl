<script type="text/javascript" id="generic">
   <!--{literal}
   function htmlescape(s) {
      return $('<div />').text(s).html();
   }
   function extract_json(data) {
      try {
         data = $.parseJSON(data);
      } catch(e) {
            alertify.alert(e + "\nData: " + data.toSource());
            return false;
      }
      if (! data.success && data.message) {
         alertify.alert('Error: ' + data.message);
      }
      return data;
   }
   //-->{/literal}
</script>
