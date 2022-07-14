{if !empty($template)}{include file=$template}{else}
	{if !empty($action)}
		{include file="$controller-$action.tpl" }
	{else}
		{include file="$controller.tpl" }
	{/if}
{/if}