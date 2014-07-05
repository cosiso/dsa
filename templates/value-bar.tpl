{if $error}
<span style="color: red">{$error|escape}</span>
{else}
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
{/if}