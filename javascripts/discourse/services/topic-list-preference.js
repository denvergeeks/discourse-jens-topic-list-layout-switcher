import { tracked } from "@glimmer/tracking";
import Service from "@ember/service";

export default class TopicListPreference extends Service {
  @tracked preference = localStorage.getItem("topicListLayout") || "";

  setPreference(value) {
    this.preference = value;
    localStorage.setItem("topicListLayout", value);

    if (this.preference === "table-ai") {
      localStorage.setItem("aiPreferred", true);
    }
  }
}
