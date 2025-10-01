import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat, fn } from "@ember/helper";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import DropdownMenu from "discourse/components/dropdown-menu";
import bodyClass from "discourse/helpers/body-class";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";
import DMenu from "float-kit/components/d-menu";

export default class TopicListLayoutToggle extends Component {
  @service router;
  @service topicListPreference;
  @service siteSettings;
  @service site;
  @service topicThumbnails; // from Topic Thumbnails theme component

  @tracked
  selectedOptionId = this.topicListPreference.preference || this.buttons[0].id;

  constructor() {
    super(...arguments);
    this.router.on("routeDidChange", this.handleRouteChange.bind(this));
  }

  updatePreference() {
    let preference = this.topicListPreference.preference;
    const gistsAvailable =
      this.router.currentRoute.attributes?.list?.topics?.some(
        (topic) => topic.ai_topic_gist
      );

    const aiPreferred = localStorage.getItem("aiPreferred");

    // if gists aren't available, switch to excerpts
    // but remember gists are preferred so we can switch back
    if (preference === "table-ai" && !gistsAvailable) {
      preference = "table-excerpts";
      this.topicListPreference.setPreference(preference);
    } else if (aiPreferred && gistsAvailable) {
      preference = "table-ai";
      this.topicListPreference.setPreference(preference);
      localStorage.removeItem("aiPreferred");
    } else {
      localStorage.removeItem("aiPreferred");
    }

    this.selectedOptionId = preference || this.buttons[0].id;

    document
      .querySelector(".topic-list")
      ?.setAttribute("data-layout", this.selectedOptionId);
  }

  handleRouteChange() {
    this.updatePreference();
  }

//  get shouldShow() {
//    const currentRoute = this.router.currentRoute.name;
//    const isDiscovery = currentRoute.includes("discovery");
//    const isNotCategories = !currentRoute.includes("categories");
//    const isNotTopicThumbnails = !this.topicThumbnails?.enabledForRoute;
//
//    return (
//      isDiscovery &&
//      isNotCategories &&
//      !this.site.mobileView &&
//      isNotTopicThumbnails
//    );
//  }


// JEN EDITED
get shouldShow() {
  const currentRoute = this.router.currentRoute.name;
  const isDiscovery = currentRoute.includes("discovery");
  const isTag = currentRoute.includes("tag");
  const isNotTopicThumbnails = !this.topicThumbnails?.enabledForRoute;

  if (isDiscovery && isNotTopicThumbnails) {
    return true;
  }

  if (isTag && isNotTopicThumbnails) {
    return true;
  }

  return false;
}
// TO HERE

  get buttons() {
    const gistsAvailable =
      this.router.currentRoute.attributes?.list?.topics?.some(
        (topic) => topic.ai_topic_gist
      );

    let buttons = [
      {
        id: "table",
        label: "toggle_labels.table",
        icon: "discourse-table",
      },
    ];

    if (gistsAvailable) {
      buttons.push({
        id: "table-ai",
        label: "toggle_labels.table_gists",
        icon: "discourse-table-sparkles",
      });
    }

    buttons.push({
      id: "table-excerpts",
      label: "toggle_labels.table_excerpts",
      icon: "discourse-table-excerpt",
    });

    buttons.push({
      id: "cards",
      label: "toggle_labels.cards",
      icon: "discourse-cards",
    });

    return buttons;
  }

  get currentButton() {
    const selectedOptionId = this.selectedOptionId;

    let match = this.buttons.find((button) => button.id === selectedOptionId);

    return match;
  }

  @action
  onRegisterApi(api) {
    this.dMenu = api;
  }

  @action
  initialPreference() {
    this.updatePreference();
  }

  @action
  onSelect(optionId) {
    this.selectedOptionId = optionId;
    document
      .querySelector(".topic-list")
      ?.setAttribute("data-layout", optionId);
    this.topicListPreference.setPreference(optionId);
    this.dMenu.close();
  }

  <template>
    {{#if this.shouldShow}}
      {{bodyClass
        (concat "topic-list-layout-" this.topicListPreference.preference)
      }}
      <DMenu
        @modalForMobile={{true}}
        @autofocus={{true}}
        @identifier="topic-list-layout"
        @onRegisterApi={{this.onRegisterApi}}
        @triggerClass="btn-default btn-icon"
        {{didInsert this.initialPreference}}
      >
        <:trigger>
          {{icon this.currentButton.icon}}
        </:trigger>
        <:content>
          <DropdownMenu as |dropdown|>
            {{#each this.buttons as |button|}}
              <dropdown.item>
                <DButton
                  @translatedLabel={{i18n (themePrefix button.label)}}
                  @icon={{button.icon}}
                  class="btn-transparent"
                  @action={{fn this.onSelect button.id}}
                />
              </dropdown.item>
            {{/each}}
          </DropdownMenu>
        </:content>
      </DMenu>
    {{/if}}
  </template>
}
