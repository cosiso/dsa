<img src="/images/bullet_orange.png"><b>Quellen: </b>
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
            <td>{{{ $cm->value }}}</td>
            <td>{{{ $cm->tradition }}}</td>
            <td>{{{ $cm->beschworung }}}</td>
            <td>{{{ $cm->wesen }}}</td>
            <td>{{{ $cm->skt }}}</td>
            <td>
               <span class="link-edit" onclick="edit_source(this)">edit</span>
               | <span class="link-cancel" onclick="remove_source(this)">remove</span>
            </td>
         </tr>
      @endforeach
      <tr>
         <td colspan="7" style="padding: 10px; text-align: right">
            <span class="link-add" onclick="add_source(this)">Add quelle</span>
         </td>
      </tr>
   </tbody>
</table><br>
<div style="padding-top: 8px">
   <img src="/images/bullet_orange.png"><b>Instruktionen: </b>
   <ul>
      @foreach($character->instruktionen as $instruktion)
         <li>{{ $instruktion->name }}</li>
      @endforeach
   </ul>
   <span class="link-add" onclick="add_instruktion(this)">Add instruktion</span><br>
   <br>
</div>
<hr>