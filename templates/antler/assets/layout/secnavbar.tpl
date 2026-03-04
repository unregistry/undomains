{foreach $navbar as $item}
    <li menuItemName="{$item->getName()}" class="{if $item->hasChildren()}dropdown{/if}{if $item->getClass()} {$item->getClass()}{/if}" id="{$item->getId()}">
        <a {if $item->hasChildren()}class="dropdown-toggle" data-toggle="dropdown" href="#"{else}href="{$item->getUri()}"{/if}{if $item->getAttribute('target')} target="{$item->getAttribute('target')}"{/if}>
            {if $item->hasIcon()}<i class="{$item->getIcon()}"></i>&nbsp;{/if}
            {$item->getLabel()}
            {if $item->hasBadge()}&nbsp;<span class="badge">{$item->getBadge()}</span>{/if}
            <i class="fa-solid fa-angle-down"></i>
            {if $item->hasChildren()}&nbsp;{/if}
        </a>
        {if $item->hasChildren()}
            <div class="dropdown-menu dropdown-toggle secundary-nav bg-colorstyle">
                <div class="secundary-header">
                    <h6 class="d-inline-block m-b-0">{$LANG.clientareadescription}</h6>
                </div>
                <ul class="secundary-content">  
                    {foreach $item->getChildren() as $childItem}
                        <li menuItemName="{$childItem->getName()}"{if $childItem->getClass()} class="{$childItem->getClass()}"{/if} id="{$childItem->getId()}">
                            <a class="mergecolor" href="{$childItem->getUri()}"{if $childItem->getAttribute('target')} target="{$childItem->getAttribute('target')}"{/if}>
                                {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}"></i>&nbsp;{/if}
                                {$childItem->getLabel()}
                                {if $childItem->hasBadge()}&nbsp;<span class="badge">{$childItem->getBadge()}</span>{/if}
                            </a>
                        </li>
                    {/foreach}
                </ul>
            </div>
        {/if}
    </li>
{/foreach}
