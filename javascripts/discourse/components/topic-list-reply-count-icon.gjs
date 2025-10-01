import Component from "@glimmer/component";
import { service } from "@ember/service";
import icon from "discourse-common/helpers/d-icon";

export default class TopicListReplyCountIcon extends Component {
  @service site;
  @service topicListPreference;
  @service topicThumbnails; // from Topic Thumbnails theme component

  get shouldShow() {
    const isCard = this.topicListPreference.preference === "cards";

    return (
      !this.site.mobileView && !this.topicThumbnails?.shouldDisplay && isCard
    );
  }

  <template>
    {{#if this.shouldShow}}
      {{icon "far-comment"}}
    {{/if}}
  </template>
}
