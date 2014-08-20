<table>
   <thead>
      <tr>
         <th>Quelle</th>
         <th>Value</th>
         <th>Tradition</th>
         <th>Essenz/Wesen</th>
         <th>Inspiration/Invokation</th>
         <th>SKT</th>
         <th></th>
      </tr>
   </thead>
   <tbody class="hover">
      @foreach($character->charmagic as $cm)
         <tr id="cm-{{ $cm->id }}">
            <td>{{{ $cm->quelle->name }}}</td>
            <td contenteditable="true">{{{ $cm->value }}}</td>
            <td>{{{ $cm->tradition }}}</td>
            <td>{{{ $cm->beschworung }}}</td>
            <td>{{{ $cm->wesen }}}</td>
            <td>{{{ $cm->skt }}}</td>
            <td>edit, remove</td>
         </tr>
      @endforeach
      <tr>
         <td colspan="7" style="padding: 10px; text-align: right">
            <span class="link-add" onclick="add_source(this)">Add quelle</span>
         </td>
      </tr>
   </tbody>
</table>