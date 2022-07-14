{assign var="tpl" value="$controller-$action.tpl"}
{if $action!=''}{include file="$tpl"}{else}{include file="$controller.tpl"}{/if}
