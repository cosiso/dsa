<table id="tbl_quellen" border="0" cellpadding="0" cellspacing="0">
   <thead>
      <tr>
         <th>Name</th>
         <th></th>
      </tr>
   </thead>
   <tbody class="hover">
      @foreach ($quellen as $quelle)
         <tr id="quelle-{{ $quelle->id }}">
            <td>{{{ $quelle->name }}}</td>
            <td>
               <span class="link-info" onclick="note_quelle(this)">description</span>
               | <span class="link-edit" onclick="show_quelle(this)">edit</span>
               | <span class="link-cancel" onclick="remove_quelle(this)">remove</span>
            </td>
         </tr>
      @endforeach
      <tr>
         <td colspan="2" style="padding-top: 10px; text-align: right">
            <span class="link-add" onclick="add_quelle()">Add quelle</span>
         </td>
      </tr>
   </tbody>
</table>
