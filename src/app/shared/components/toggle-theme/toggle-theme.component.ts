import { Component, OnInit } from '@angular/core';
import { ThemeService } from '../../services/theme.service';

@Component({
  selector: 'app-toggle-theme',
  templateUrl: './toggle-theme.component.html',
  styleUrls: ['./toggle-theme.component.scss']
})
export class ToggleThemeComponent implements OnInit {
  public isDarkMode = false;

  constructor(private themeService: ThemeService) {
    this.isDarkMode = themeService.isDarkMode();
  }

  ngOnInit(): void {
  }

  toggleTheme() {
    // const body = document.getElementsByTagName('body')[0];
    // body.classList.toggle('dark-theme');
    this.themeService.toggleTheme();
  }
}
