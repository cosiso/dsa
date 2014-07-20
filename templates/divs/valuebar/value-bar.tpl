{if $error}
<span style="color: red">{$error|escape}</span>
{else}
{custom_hidden name='vb_char_id' value=$char_id}
<b>MU: </b>{$mu}
<b>KL: </b>{$kl}
<b>IN: </b>{$in}
<b>CH: </b>{$ch}
<b>FF: </b>{$ff}
<b>GE: </b>{$ge}
<b>KO: </b>{$ko}
<b>KK: </b>{$kk}
<b>INI: </b>{$ini}
<b>FK: </b>{$fk}
<br>
<b>LE:</b> <span id="vb_le">{$le}</span>
<b>AU:</b> <span id="vb_au">{$au}</span>
<b>AE:</b> <span id="vb_ae">{$ae}</span>
{custom_spacer width=250}
Lost LE: {custom_text name='lost_le' style='width: 2em; height: 14px' onchange="vb_change('le', this)" value=$le_used onfocus="vb_focus('le', this)"}
{custom_spacer width=8}
Lost AU: {custom_text name='lost_au' style='width: 2em; height: 14px' onchange="vb_change('au', this)" value=$au_used onfocus="vb_focus('au', this)"}
{custom_spacer width=8}
Lost AE: {custom_text name='lost_ae' style='width: 2em; height: 14px' onchange="vb_change('ae', this)" value=$ae_used onfocus="vb_focus('ae', this)"}
{/if}